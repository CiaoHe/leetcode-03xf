# [530. 二叉搜索树的最小绝对差](https://leetcode.cn/problems/minimum-absolute-difference-in-bst/)
谢谢你，in-order侠
```python fold
class Solution:
    def getMinimumDifference(self, root: Optional[TreeNode]) -> int:
        # in-order traversal
        inorder = []
        def dfs(root: Optional[TreeNode]):
            if not root:
                return
            dfs(root.left)
            inorder.append(root.val)
            dfs(root.right)
        dfs(root)
        return min(abs(inorder[i] - inorder[i - 1]) for i in range(1, len(inorder)))
```
# [230. 二叉搜索树中第 K 小的元素](https://leetcode.cn/problems/kth-smallest-element-in-a-bst/)
谢谢你，in-order侠
```python fold
class Solution:
    def kthSmallest(self, root: Optional[TreeNode], k: int) -> int:
        in_order = []
        def dfs(root):
            if not root:
                return
            dfs(root.left)
            in_order.append(root.val)
            dfs(root.right)
        dfs(root)
        return in_order[k-1]
```
# [98. 验证二叉搜索树](https://leetcode.cn/problems/validate-binary-search-tree/)
```python fold
class Solution:
    def isValidBST(self, root: Optional[TreeNode]) -> bool:
        if root.left:
            # find the max value in left subtree
            left_max = root.left
            while left_max.right:
                left_max = left_max.right
            left_flag = root.val > left_max.val and self.isValidBST(root.left)
        else:
            left_flag = True
        
        if root.right:
            right_min = root.right
            while right_min.left:
                right_min = right_min.left
            right_flag = root.val < right_min.val and self.isValidBST(root.right)
        else:
            right_flag = True
        return left_flag and right_flag
```