document.addEventListener('DOMContentLoaded', function () {
    document.querySelectorAll('.delete-comment').forEach(function (button) {
        button.addEventListener('click', function () {
            var commentId = this.getAttribute('data-comment-id');
            var commentUserId = this.getAttribute('data-user-id');

            deleteComment(commentId, commentUserId);
        });
    });

    // Attach click event listeners to all edit buttons
    document.querySelectorAll('.edit-comment-button').forEach(function (button) {
        button.addEventListener('click', function (event) {
            event.stopPropagation(); // Prevent click event from propagating to parent elements

            var commentId = this.getAttribute('data-comment-id');
            var commentTextElement = document.querySelector(`[data-comment-id="${commentId}"]`);
            var currentText = commentTextElement.textContent;

            // Replace comment text with an input field
            var inputField = document.createElement('input');
            inputField.type = 'text';
            inputField.value = currentText;
            commentTextElement.innerHTML = '';
            commentTextElement.appendChild(inputField);

            // Create a save button
            var saveButton = document.createElement('button');
            saveButton.textContent = 'Save';
            saveButton.addEventListener('click', function () {
                var updatedText = inputField.value;

                // Check if the text has changed
                if (updatedText !== currentText) {
                    editComment(commentId, updatedText);
                } else {
                    // If text hasn't changed, revert back to displaying the text
                    commentTextElement.textContent = currentText;
                }
            });

            // Create a cancel button
            var cancelButton = document.createElement('button');
            cancelButton.textContent = 'Cancel';
            cancelButton.addEventListener('click', function () {
                // Revert back to displaying the original text
                commentTextElement.textContent = currentText;
            });

            commentTextElement.appendChild(saveButton);
            commentTextElement.appendChild(cancelButton);
        });
    });

    function deleteComment(commentId, commentUserId) {
        var loggedInUserId = '{{ request.user.id }}';

        if (commentUserId !== loggedInUserId) {
            alert('You do not have permission to delete this comment.');
            return;
        }

        // Add a confirmation dialog
        var confirmDelete = confirm("Are you sure you want to delete this comment?");
        if (!confirmDelete) {
            return; // Exit the function if the user did not confirm
        }

        console.log('Fetching...');

        fetch(`/delete_comment/${commentId}/`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'X-CSRFToken': '{{ csrf_token }}'
            },
            body: JSON.stringify({}),
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                var commentElement = document.querySelector(`[data-comment-id="${commentId}"]`).closest('p');
                if (commentElement) {
                    commentElement.parentNode.removeChild(commentElement);
                }
            } else {
                console.error('Failed to delete comment:', data.error);
            }
        })
        .catch(error => {
            console.error('Error during delete comment request:', error);
        });
    }

    function editComment(commentId, commentText) {
        fetch(`/edit_comment/${commentId}/`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
                'X-CSRFToken': '{{ csrf_token }}'
            },
            body: new URLSearchParams({
                'new_text': commentText,
            }),
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                var commentElement = document.querySelector(`[data-comment-id="${commentId}"]`);
                if (commentElement) {
                    commentElement.textContent = commentText;
                }
            } else {
                console.error('Failed to edit comment:', data.error);
            }
        })
        .catch(error => {
            console.error('Error during edit comment request:', error);
        });
    }
    });