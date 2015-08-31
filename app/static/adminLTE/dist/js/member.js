jQuery(".member-card").easyModal({
	overlay:0.2
});

function closeModal() {
	jQuery(".member-card").trigger("closeModal");
}