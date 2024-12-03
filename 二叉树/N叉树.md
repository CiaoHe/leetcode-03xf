#  [427. 建立四叉树](https://leetcode.cn/problems/construct-quad-tree/)
1. 先检查矩阵内所有位置是不是全部值都一样
2. 如果值是一样的(all 0/1)，树结点的 val 设为对应的布尔值，isLeaf 设为 true 表示没有孩子结点并将四个孩子结点指针设为 null, 结束并返回
3. 如果矩阵内值不全是一样的，那么 isLeaf 设置为 false 表示还有孩子结点（这种情况 val 无意义随便设置不影响）然后画个十字将矩阵等分成四个正方形小矩阵，对每个小矩阵递归执行上述步骤并将当前树结点的四个孩子指针指向"递归操作返回的四个树结点"（具体哪个指针指向哪个结点可以看图理解）.
```python fold
class Solution:
    def construct(self, grid: List[List[int]]) -> 'Node':
        n = len(grid)
        
        # Base case: if the grid is 1x1, return a leaf node
        if n == 1:
            return Node(grid[0][0], True, None, None, None, None)
        
        # Recursively construct the four quadrants
        half = n // 2
        topLeft = self.construct([row[:half] for row in grid[:half]])
        topRight = self.construct([row[half:] for row in grid[:half]])
        bottomLeft = self.construct([row[:half] for row in grid[half:]])
        bottomRight = self.construct([row[half:] for row in grid[half:]])
        
        # Check if all four quadrants are leaf nodes with the same value
        if (topLeft.isLeaf and topRight.isLeaf and bottomLeft.isLeaf and bottomRight.isLeaf and
            topLeft.val == topRight.val == bottomLeft.val == bottomRight.val):
            return Node(topLeft.val, True, None, None, None, None)
        
        # If not, create a non-leaf node with the four quadrants as children
        return Node(1, False, topLeft, topRight, bottomLeft, bottomRight)
```

