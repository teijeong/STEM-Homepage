# returns tuple (add, sub)
# add: elements that are added to target
# sub: elements that are removed from original 
def list_diff(original, target):
	original = set(original)
	target = set(target)
	return (list(target-original), list(original-target))