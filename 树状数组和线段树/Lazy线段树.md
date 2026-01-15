# [3454. 分割正方形 II](https://leetcode.cn/problems/separate-squares-ii/)
给你一个二维整数数组 `squares` ，其中 `squares[i] = [xi, yi, li]` 表示一个与 x 轴平行的正方形的左下角坐标和正方形的边长。

找到一个**最小的** y 坐标，它对应一条水平线，该线需要满足它以上正方形的总面积 **等于** 该线以下正方形的总面积。

答案如果与实际答案的误差在 `10-5` 以内，将视为正确答案。

**<span style="color:rgb(255, 0, 0)">注意**：正方形 **可能会** 重叠。重叠区域只 **统计一次** 。</span> 

```python
class Node:
    def __init__(self):
        self.l = self.r = 0 # 节点代表的区间在离散化数组中的左右索引
        self.cnt = self.length = 0 # cnt: 区间被覆盖的次数，length: 区间有效长度

class SegmentTree:
    def __init__(self, nums):
        # 区间数量 = len(nums)-1
        n = len(nums) - 1
        self.nums = nums
        self.tr = [Node() for _ in range(n<<2)] # 线段树节点数 = 4*n
        self.build(1, 0, n-1)

    def build(self, u, l, r):
        # u: 当前节点编号
        # l, r: 区间左右端点
        self.tr[u].l = l
        self.tr[u].r = r
        if l!=r: # 如果左右端点不同->不是叶子节点->需要递归构建左右子树
            mid = (l + r) // 2
            self.build(u<<1, l, mid)
            self.build(u<<1|1, mid+1, r)
    
    def modify(self, u, l, r, k):
        # u: 当前节点编号
        # l, r: 要修改的区间左右端点
        # k: 修改值 (1表示添加，-1表示移除)
        if self.tr[u].l >= l and self.tr[u].r <= r:
            self.tr[u].cnt += k
        else:
            mid = (self.tr[u].l + self.tr[u].r) >> 1
            if l <= mid:
                self.modify(u<<1, l, r, k)
            if r > mid:
                self.modify(u<<1|1, l, r, k)
        self.pushup(u)

    def pushup(self, u):
        # 更新节点u的长度信息
        if self.tr[u].cnt:
            self.tr[u].length = self.nums[self.tr[u].r+1] - self.nums[self.tr[u].l]
        elif self.tr[u].l == self.tr[u].r: # 叶子节点且没有被覆盖->长度为0
            self.tr[u].length = 0
        else: # 非叶子节点->长度为左右子树长度之和
            self.tr[u].length = self.tr[u<<1].length + self.tr[u<<1|1].length
    
    @property
    def length(self):
        return self.tr[1].length # 根节点代表整个区间->返回整个区间的有效长度


class Solution:
    def separateSquares(self, squares: List[List[int]]) -> float:
        # 离散化
        xs = set()
        segs = [] # 扫描线事件：(y坐标, x1, x2, 类型) 类型:1-开始边，-1-结束边

        for x1, y1, l in squares:
            x2, y2 = x1 + l, y1 + l
            xs.update([x1, x2]) # 添加离散化点
            segs.append((y1, x1, x2, 1))
            segs.append((y2, x1, x2, -1))
        
        # 对扫描线事件按y坐标排序
        segs.sort()

        # 离散化x坐标
        xs = sorted(xs)

        # 建立线段树
        tree = SegmentTree(xs)
        d = {x:i for i, x in enumerate(xs)} # 建立坐标到索引的映射

        # 计算total_area
        total_area = 0
        y0 = 0 # 上一个y坐标
        for y, x1, x2, k in segs:
            total_area += (y - y0) * tree.length # 计算当前y坐标下的面积
            y0 = y
            tree.modify(1, d[x1], d[x2]-1, k) # 更新线段树 注意：x2-1是因为线段树的区间是左闭右开
        
        # 寻找分割线
        target = total_area / 2
        area = 0 # 当前累计面积
        y0 = 0 # 上一个y坐标
        
        for y, x1, x2, k in segs:
            t = (y - y0) * tree.length # 计算当前y坐标下的面积
            if area + t >= target:
                return y0 + (target - area) / tree.length
            area += t
            tree.modify(1, d[x1], d[x2]-1, k) # 更新线段树
            y0 = y
        return 0
```