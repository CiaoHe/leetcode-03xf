#  [101. 对称二叉树](https://leetcode.cn/problems/symmetric-tree/)
```python
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


# [1339. 分裂二叉树的最大乘积](https://leetcode.cn/problems/maximum-product-of-splitted-binary-tree/)
给你一棵二叉树，它的根为 `root` 。请你删除 1 条边，使二叉树分裂成两棵子树，且它们子树和的乘积尽可能大。

由于答案可能会很大，请你将结果对 10^9 + 7 取模后再返回。

```python
# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, val=0, left=None, right=None):
#         self.val = val
#         self.left = left
#         self.right = right
class Solution:
    def maxProduct(self, root: Optional[TreeNode]) -> int:
        MOD = 10**9 + 7
        def dfs(node: Optional[TreeNode]) -> int:
            if node is None:
                return 0
            return node.val + dfs(node.left) + dfs(node.right)
        total = dfs(root)
        
        self.ans = 0
        def dfs2(node):
            if not node:
                return 0
            left_sum = dfs2(node.left)
            right_sum = dfs2(node.right)
            subtree_sum = node.val + left_sum + right_sum
            self.ans = max(self.ans, subtree_sum * (total - subtree_sum))
            return subtree_sum
        dfs2(root)
        return self.ans % MOD
```