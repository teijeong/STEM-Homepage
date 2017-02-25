jQuery(function() {
	jQuery(".member-card").easyModal({
	overlay:0.2,
    overlayParent: jQuery("#memberlist"),
	zIndex: function () { console.log("AaAAAH"); return 100;},
    onOpen: function(modal) {
    }
})
});

function closeModal() {
	jQuery(".member-card").trigger("closeModal");
}
