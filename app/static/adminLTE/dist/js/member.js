jQuery("[class^=member-card]").easyModal({
	overlay:0.2
});

function closeModal() {
	jQuery("[class^=member-card]").trigger("closeModal");
}
