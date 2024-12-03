#  [101. 对称二叉树](https://leetcode.cn/problems/symmetric-tree/)
```python fold
class Solution:
    def isSymmetric(self, root: Optional[TreeNode]) -> bool:        
        def dfs(L,R):
            if not L and not R:
                return True
            if not L or not R or L.val!=R.val:
                return False
            return dfs(L.left, R.right) and dfs(L.right, R.left)
        
        if not root:
            return True
        return dfs(root.left, root.right)
```