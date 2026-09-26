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
# [2265. 统计值等于子树平均值的节点数](https://leetcode.cn/problems/count-nodes-equal-to-average-of-subtree/)
给你一棵二叉树的根节点 `root` ，找出并返回满足要求的节点数，要求节点的值等于其 **子树** 中值的 **平均值** 。

**注意：**
- `n` 个元素的平均值可以由 `n` 个元素 **求和** 然后再除以 `n` ，并 **向下舍入** 到最近的整数。
- `root` 的 **子树** 由 `root` 和它的所有后代组成。

```python
# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, val=0, left=None, right=None):
#         self.val = val
#         self.left = left
#         self.right = right
class Solution:
    def averageOfSubtree(self, root: TreeNode) -> int:
        self.res = 0
        def dfs(node):
            if not node:
                return (0,0)
            left_sum, left_count = dfs(node.left)
            right_sum, right_count = dfs(node.right)
            total_sum = left_sum + right_sum + node.val
            total_count = left_count + right_count + 1
            if total_sum // total_count == node.val:
                self.res += 1
            return (total_sum, total_count)
        dfs(root)
        return self.res
```