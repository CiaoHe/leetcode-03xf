# [450. 删除二叉搜索树中的节点](https://leetcode.cn/problems/delete-node-in-a-bst/)
 删除二叉树：
 难点是 如果root.val == key
 1. 如果root是叶子节点，则直接删除
 2. 如果root只有左子树，则删除root，并把左子树作为新的root
 3. 如果root只有右子树，则删除root，并把右子树作为新的root
 4. 如果root既有左子树又有右子树，新的root是右子树的最小节点
	 1. 一路找到root.right 的 left中left
```python
class Solution:
    def deleteNode(self, root: Optional[TreeNode], key: int) -> Optional[TreeNode]:
        if not root:
            return None
        if root.val == key:
            if not root.left and not root.right:
                return None
            elif not root.left:
                return root.right
            elif not root.right:
                return root.left
            else:
                cur = root.right
                while cur.left:
                    cur = cur.left
                cur.right = self.deleteNode(root.right, cur.val)
                cur.left = root.left
                return cur
        elif root.val > key:
            root.left = self.deleteNode(root.left, key)
        else:
            root.right = self.deleteNode(root.right, key)
        return root
```