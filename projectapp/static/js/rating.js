function updateRating(n) {
    const stars = document.querySelectorAll('.star');
    let cls;

    for (let i = 0; i < n; i++) {
        if (n == 1) cls = "one";
        else if (n == 2) cls = "two";
        else if (n == 3) cls = "three";
        else if (n == 4) cls = "four";
        else if (n == 5) cls = "five";

        stars[i].className = "star " + cls;
    }

    const outputText = document.getElementById('outputText');
    outputText.innerText = "Rating is: " + n + "/5";

    const form = document.getElementById('ratingForm');
    
    // Get CSRF token and append it to FormData
    const csrfToken = document.getElementsByName('csrfmiddlewaretoken')[0].value;
    const formData = new FormData(form);
    formData.append('csrfmiddlewaretoken', csrfToken);

    $.ajax({
        type: 'POST',
        url: '/update_rating/',
        data: formData,
        processData: false,
        contentType: false,
        success: function(response) {
            if (response.success) {
                const averageRating = response.average_rating;
                const averageRatingElement = document.getElementById('average-rating');

                if (averageRating) {
                    averageRatingElement.innerHTML = `Average Rating: ${averageRating.toFixed(1)} / 5`;
                } else {
                    averageRatingElement.innerHTML = 'No ratings yet.';
                }

                // Show a success message
                alert('Rating added successfully!');
            } else {
                // Show an error message if needed
                alert('Failed to add rating. Please try again.');
            }
        },
        error: function(error) {
            console.log(error);
            // Show an error message
            alert('An error occurred. Please try again later.');
        }
    });
}
