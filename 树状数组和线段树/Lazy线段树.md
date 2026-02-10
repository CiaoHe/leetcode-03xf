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

# [3719. 最长平衡子数组 I](https://leetcode.cn/problems/longest-balanced-subarray-i/)
给你一个整数数组 `nums`。
如果子数组中 **不同偶数** 的数量等于 **不同奇数** 的数量，则称该 **子数组** 是 **平衡的** 。
返回 **最长** 平衡子数组的长度。
**子数组** 是数组中连续且 **非空** 的一段元素序列。

> 滑动窗口算法并不适用于“不同元素的计数”. 因为没有单调性
> 标准滑动窗口适用于：“如果当前窗口太大/不满足条件，缩小左边界一定能让它趋向满足”。
> 
```python
class Solution:
    def longestBalanced(self, nums: List[int]) -> int:
        n = len(nums)
        ans = 0
        for l in range(n):
            odd = set()
            even = set()
            for r in range(l, n):
                if nums[r] % 2 == 0:
                    even.add(nums[r])
                else:
                    odd.add(nums[r])
                if len(odd) == len(even):
                    ans = max(ans, r - l + 1)
        return ans
```

# [3721. 最长平衡子数组 II](https://leetcode.cn/problems/longest-balanced-subarray-ii/)
[[3721. 最长平衡子数组 II](https://leetcode.cn/problems/longest-balanced-subarray-ii/)](#[3721.%20最长平衡子数组%20II](https%20//leetcode.cn/problems/longest-balanced-subarray-ii/)) 的进阶
我们固定右端点 `r`，让它从 `0` 走到 `n-1`。对于当前的 `r`，我们需要找到一个最小的左端点 `l` ($0 \le l \le r$)，使得子数组 `nums[l...r]` 中：

$$\text{不同偶数数量} - \text{不同奇数数量} = 0$$

我们维护一棵线段树，线段树的第 `i` 个叶子节点的值表示：
**以 `i` 为左端点，当前 `r` 为右端点的子数组的“平衡值”**。
即 `Tree[i] = CountDistinctEven(nums[i...r]) - CountDistinctOdd(nums[i...r])`。

状态转移（区间更新）
	当 `r` 向右移动，加入一个新数字 `x = nums[r]` 时：
	1. 如果 `x` 是 **偶数**：它会让所有包含它的子数组的“偶数计数”加 1。
	    - 哪些子数组包含这个新的 `x`？左端点在 `(last_pos[x], r]` 范围内的子数组。
	    - **操作：** 线段树区间 `[last_pos[x] + 1, r]` 的值 **+1**。
	2. 如果 `x` 是 **奇数**：同理，它会让“奇数计数”加 1（即平衡值减 1）。
	    - **操作：** 线段树区间 `[last_pos[x] + 1, r]` 的值 **-1**。
> 这里又和[[525. 连续数组](https://leetcode.cn/problems/contiguous-array/)](前缀和与哈希表.md#[525.%20连续数组](https%20//leetcode.cn/problems/contiguous-array/))(前缀和与哈希表.md)] 这里颇为相似

查询（线段树二分）
	更新完后，我们需要在区间 `[0, r]` 内找到**最左边**的一个索引 `l`，使得 `Tree[l] == 0`。 为了快速找到这个 `0`，线段树的每个节点需要维护区间内的 **最小值 (min)** 和 **最大值 (max)**。
	- 如果一个节点的 `min <= 0` 且 `max >= 0`，说明这个区间内存在 0。
	- 我们优先递归左子树寻找，找不到再找右子树（贪心寻找最左侧）。

```python
from typing import List

class SegmentTree:
    def __init__(self, n: int):
        self.n = n
        # 4倍空间防止越界
        self.tree_min = [0] * (4 * n)
        self.tree_max = [0] * (4 * n)
        self.lazy = [0] * (4 * n)

    def _push_down(self, node: int):
        """下放懒标记"""
        if self.lazy[node] != 0:
            val = self.lazy[node]
            left, right = 2 * node, 2 * node + 1
            
            self.lazy[left] += val
            self.tree_min[left] += val
            self.tree_max[left] += val
            
            self.lazy[right] += val
            self.tree_min[right] += val
            self.tree_max[right] += val
            
            self.lazy[node] = 0

    def _push_up(self, node: int):
        """向上合并"""
        left, right = 2 * node, 2 * node + 1
        self.tree_min[node] = min(self.tree_min[left], self.tree_min[right])
        self.tree_max[node] = max(self.tree_max[left], self.tree_max[right])

    def update(self, L: int, R: int, val: int):
        """外部调用接口：区间 [L, R] 加上 val"""
        self._update(1, 0, self.n - 1, L, R, val)

    def _update(self, node: int, start: int, end: int, L: int, R: int, val: int):
        """内部递归更新"""
        # 目标搜索范围 [start, end] 正好在本节点范围 [L, R]里面
        if L <= start and end <= R:
            self.lazy[node] += val
            self.tree_min[node] += val
            self.tree_max[node] += val
            return

        self._push_down(node)
        mid = (start + end) // 2
        
        if L <= mid:
            self._update(2 * node, start, mid, L, R, val)
        if R > mid:
            self._update(2 * node + 1, mid + 1, end, L, R, val)
        
        self._push_up(node)

    def find_first_zero(self, limit_r: int) -> int:
        """外部调用接口：查找 <= limit_r 的范围内，最左侧值为 0 的索引"""
        return self._query(1, 0, self.n - 1, limit_r)

    def _query(self, node: int, start: int, end: int, limit_r: int) -> int:
        """内部递归查询"""
        # 剪枝：如果 0 不在该节点的值域范围内，直接返回 -1
        # 这利用了 min 和 max 快速判断 0 是否存在
        if self.tree_min[node] > 0 or self.tree_max[node] < 0:
            return -1
        
        # 叶子节点
        if start == end:
            return start if start <= limit_r else -1

        self._push_down(node)
        mid = (start + end) // 2
        
        # 贪心策略：优先查左子树
        res = -1
        if 0 <= mid: # 边界保护
            res = self._query(2 * node, start, mid, limit_r)
            
        # 左边找到了直接返回，否则查右边
        if res != -1:
            return res
        
        # 只有在右子树范围还在 limit_r 内时才查右边
        if limit_r > mid:
            return self._query(2 * node + 1, mid + 1, end, limit_r)
            
        return -1


class Solution:
    def longestBalanced(self, nums: List[int]) -> int:
        n = len(nums)
        st = SegmentTree(n)
        last_pos = {}  # 记录元素上一次出现的位置
        ans = 0

        for r, x in enumerate(nums):
            # 获取上一次该数字出现的位置，如果没出现过则是 -1
            prev = last_pos.get(x, -1)
            
            # 偶数贡献 +1，奇数贡献 -1
            delta = 1 if x % 2 == 0 else -1
            
            # 核心逻辑：
            # 只有从 (prev, r] 这段区间开始的子数组，
            # 才会包含到这个“新”出现的 x，从而影响它们的“不同计数”。
            st.update(prev + 1, r, delta) # 在[prev+1, r]范围内更新delta的影响
            
            # 更新当前数字的位置
            last_pos[x] = r
            
            # 在 [0, r] 范围内寻找最靠左的 l，使得 diff[l...r] == 0
            l = st.find_first_zero(r)
            
            if l != -1:
                ans = max(ans, r - l + 1)
                
        return ans
```