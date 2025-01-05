# [104. 二叉树的最大深度](https://leetcode.cn/problems/maximum-depth-of-binary-tree/)
```python
class Solution:
    def maxDepth(self, root: Optional[TreeNode]) -> int:
        if not root: return 0
        return max(self.maxDepth(root.left), self.maxDepth(root.right)) + 1
```
# [111. 二叉树的最小深度](https://leetcode.cn/problems/minimum-depth-of-binary-tree/)
注意如果left/right为空，那么将不能简单返回0
```python
class Solution:
    def minDepth(self, root: Optional[TreeNode]) -> int:
        if not root: return 0
        if not root.left and not root.right:
            return 1
        if not root.left and root.right:
            return self.minDepth(root.right) + 1
        if root.left and not root.right:
            return self.minDepth(root.left) + 1
        return min(self.minDepth(root.left), self.minDepth(root.right)) + 1
```
# [100. 相同的树](https://leetcode.cn/problems/same-tree/)
```python
class Solution:
    def isSameTree(self, p: Optional[TreeNode], q: Optional[TreeNode]) -> bool:
        if not p and not q:
            return True
        if not p or not q:
            return False
        if p.val != q.val:
            return False
        return self.isSameTree(p.left, q.left) and self.isSameTree(p.right, q.right)
```
# [LCR 143. 子结构判断](https://leetcode.cn/problems/shu-de-zi-jie-gou-lcof/)
[[100. 相同的树](https://leetcode.cn/problems/same-tree/)](#[100.%20相同的树](https%20//leetcode.cn/problems/same-tree/))拓展
```python
class Solution:
    def isSubStructure(self, A: Optional[TreeNode], B: Optional[TreeNode]) -> bool:
        if not A or not B:
            return False
        
        def dfs(a:TreeNode, b:TreeNode)->bool:
            if not b: # b为空，说明b已经遍历完了
                return True
            if not a: # a空了，但是b没空
                return False
            if a.val != b.val: # 值不相等
                return False
            # 值相等，继续遍历
            return dfs(a.left, b.left) and dfs(a.right, b.right)
        
        return dfs(A, B) or self.isSubStructure(A.left, B) or self.isSubStructure(A.right, B)
```
#  [112. 路径总和](https://leetcode.cn/problems/path-sum/)
```python
class Solution:
    def hasPathSum(self, root: Optional[TreeNode], targetSum: int) -> bool:
        if not root:
            return False
        # like Two Sum
        if not root.left and not root.right:
            return root.val == targetSum
        return self.hasPathSum(root.left, targetSum - root.val) or self.hasPathSum(root.right, targetSum - root.val)
```
# [199. 二叉树的右视图](https://leetcode.cn/problems/binary-tree-right-side-view/)
BFS
```python
class Solution:
    def rightSideView(self, root: Optional[TreeNode]) -> List[int]:
        if not root:
            return []
        res = []
        q = deque([root])
        while q:
            size = len(q)
            for _ in range(size):
                node = q.popleft()
                if _ == size - 1:
                    res.append(node.val)
                if node.left:
                    q.append(node.left)
                if node.right:
                    q.append(node.right)
        return res
```