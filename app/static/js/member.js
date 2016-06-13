jQuery(".member-card").easyModal({
	top: 200,
	overlay:0.2,
    overlayParent: jQuery(".wrapper"),
	zIndex: function () { console.log("AaAAAH"); return 100;},
    opOpen: function(modal) {
    }
});

function closeModal() {
	jQuery(".member-card").trigger("closeModal");
}
