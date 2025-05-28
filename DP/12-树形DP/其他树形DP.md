# [2920. 收集所有金币可获得的最大积分](https://leetcode.cn/problems/maximum-points-after-collecting-coins-from-all-nodes/)
- 选择第二种 等价于 右移1位
- 设计子问题： `dfs(i,j)`: 从i出发，选择右移j位，能获得的最大值
- 选择第一种
	- `dfs(i,j) = (coins[i]>>j) - k + sum(dfs(ch, j) for ch in g[i])`
- 选择第二种
	- `dfs(i,j) = (coins[i]>>j+1) + sum(dfs(ch, j+1) for ch in g[i])`
```python
class Solution:
    def maximumPoints(self, edges: List[List[int]], coins: List[int], k: int) -> int:
        g = defaultdict(list)
        for u, v in edges:
            g[u].append(v)
            g[v].append(u)
            
        @lru_cache(None)
        def dfs(i, j, fa):
            # 设置fa防止回溯回去
            res1 = (coins[i]>>j) - k 
            res2 = (coins[i]>>j+1)
            for ch in g[i]:
                if ch == fa:
                    continue
                res1 += dfs(ch, j, i)
                # 本题范围内，coins[i]的二进制表示最多有14位
                if j < 14:
                    res2 += dfs(ch, j+1, i)
            return max(res1, res2)
        return dfs(0, 0, -1)
```
# [3068. 最大节点价值之和](https://leetcode.cn/problems/find-the-maximum-sum-of-node-values/)
给你一棵 `n` 个节点的 **无向** 树，节点从 `0` 到 `n - 1` 编号。树以长度为 `n - 1` 下标从 **0** 开始的二维整数数组 `edges` 的形式给你，其中 `edges[i] = [ui, vi]` 表示树中节点 `ui` 和 `vi` 之间有一条边。同时给你一个 **正** 整数 `k` 和一个长度为 `n` 下标从 **0** 开始的 **非负** 整数数组 `nums` ，其中 `nums[i]` 表示节点 `i` 的 **价值** 。

Alice 想 **最大化** 树中所有节点价值之和。为了实现这一目标，Alice 可以执行以下操作 **任意** 次（**包括** **0 次**）：

- 选择连接节点 `u` 和 `v` 的边 `[u, v]` ，并将它们的值更新为：
    - `nums[u] = nums[u] XOR k`
    - `nums[v] = nums[v] XOR k`

请你返回 Alice 通过执行以上操作 **任意次** 后，可以得到所有节点 **价值之和** 的 **最大值** 。

1. 操作的本质
	- **XOR 的性质：** a XOR k XOR k = a。这意味着对同一个节点执行两次 XOR k 操作会使其值恢复原样。
	- **边的连接性：** 操作总是作用于两个相连的节点。
	- **传播效应：** 如果你对 [u, v] 操作，然后对 [v, w] 操作，那么 v 实际上被 XOR k 了两次（一次来自 u，一次来自 w），所以 nums[v] 会恢复原样。只有 u 和 w 最终被 XOR k 了一次。
2. 关键观察：操作对节点的影响只取决于它被 XOR k 的次数。
	- **偶数次 XOR k：** 节点值不变。
	- **奇数次 XOR k：** 节点值变为 nums[i] XOR k。
3. 将问题转化为：每个节点是否最终被 XOR k 一次
	1. 我们最终关心的不是某个边被操作了多少次，而是每个节点的 nums[i] 是保持原样，还是变成了 nums[i] XOR k。
4. 建模每个节点的状态：
	- 假设每个节点 i 有一个状态 state[i]，其中 state[i] = 0 表示 nums[i] 最终保持原样，state[i] = 1 表示 nums[i] 最终变为 nums[i] XOR k。
5. 操作与状态的关系：**
	考虑一条边 [u, v] 被操作。
	- 如果 u 和 v 都没有被操作过，操作 [u, v] 会让 state[u] 和 state[v] 都从 0 变为 1。
	- 如果 u 已经被操作过一次（state[u]=1），v 没有被操作过（state[v]=0），操作 [u, v] 会让 state[u] 变回 0，state[v] 变为 1。
	- 总结：**操作一条边 [u, v] 相当于翻转了 state[u] 和 state[v] 的值。** (0->1, 1->0)

```python
class Solution:
    def maximumValueSum(self, nums: List[int], k: int, edges: List[List[int]]) -> int:
        n = len(nums)
        # adjunct 
        adj = [[] for _ in range(n)]
        for u, v in edges:
            adj[u].append(v)
            adj[v].append(u)
        
        @lru_cache
        def dfs(u, p):
            # u: current node
            # p: parent node

            # 1.初始化current_dp_u0: 当前以u为root且不进行xor(或者进行了偶数次的xor)
            current_dp_u0 = nums[u]
            current_dp_u1 = nums[u] ^ k

            # 2. 遍历u的邻居节点v
            for v in adj[u]:
                if v == p:
                    continue
                
                child_dp_v0, child_dp_v1 = dfs(v, u)

                prev_dp_u0 = current_dp_u0
                prev_dp_u1 = current_dp_u1

                # 3. 更新current_dp_u0和current_dp_u1
                current_dp_u0 = max(prev_dp_u0 + child_dp_v0, prev_dp_u1 + child_dp_v1)
                current_dp_u1 = max(prev_dp_u0 + child_dp_v1, prev_dp_u1 + child_dp_v0)
                
            return current_dp_u0, current_dp_u1
        
        # 4. 从根节点开始dfs
        final_dp_0, final_dp_1 = dfs(0, -1)
        return final_dp_0
    
```