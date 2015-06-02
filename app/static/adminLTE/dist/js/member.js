jQuery(".member-card").easyModal({
	top: 200,
	overlay:0.2,
    //overlayParent: jQuery(".con"),
    opOpen: function(modal) {
        concole.log(memberListScope.pIndex);
    }
});

function closeModal() {
	jQuery(".member-card").trigger("closeModal");
}