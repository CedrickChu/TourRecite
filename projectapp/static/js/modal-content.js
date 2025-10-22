var modal = document.getElementById("imageModal");

window.onclick = function(event) {
    if (event.target === modal) {
        closeModal();
    }
};

function openModal(imageUrl) {
    var modal = document.getElementById("imageModal");
    var modalImage = document.getElementById("modalImage");

    modal.style.display = "block";
    modalImage.src = imageUrl;
}

function closeModal() {
    var modal = document.getElementById("imageModal");
    modal.style.display = "none";
}
