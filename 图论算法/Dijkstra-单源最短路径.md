# 基础模版
带堆的优化
```python
# build graph
g = [[] for _ in range(n)]
for u,v,w in edges:
	g[u].append([v,w])
	g[v].append([u,w])
dis = [inf]*n # 从0到达各个点的距离
dis[0] = 0 

# 用heap来优化
h = [[0,0]]
while h:
	dx,x = heappop(h)
	for y,w in g[x]:
		if dx+w<dis[y]:
			dis[y] = dx+w
			heappush(h, [dx+w, y])
for i,value in enumerate(dis):
	if value is inf:
		dis[i] = -1
return dis
```
# [743. 网络延迟时间](https://leetcode.cn/problems/network-delay-time/)
从任何一点出发（e.g., k)
```python
class Solution:
    def networkDelayTime(self, times: List[List[int]], n: int, k: int) -> int:
        g = [[] for _ in range(n)]
        for u,v,w in times:
            g[u-1].append((v-1,w))
        dis = [inf]*n 
        dis[k-1] = 0
        h = [[0,k-1]]
        while h:
            dx, x = heappop(h)
            if dx > dis[x]:
                continue
            for nx,w in g[x]:
                new_dx = dx + w
                if new_dx < dis[nx]:
                    dis[nx] = new_dx
                    heappush(h, [new_dx, nx])
        if inf in dis:
            return -1
        return max(dis)
```
---

# 带状态的模版
限定更新`K`步
- 注意一个很重要的点在于 不能### 直接更新 `dis[y]=dx+w`
	- 在标准的 Dijkstra 算法中，`dis[y]` 的作用是记录从起点到节点 `y` 的**最短距离**。如果找到一条更短的路径，就更新 `dis[y]`。然而，在这个问题中，你还需要考虑中转次数的限制。即使你找到了一条更短的路径，但如果这条路径的中转次数超过了限制 `k`，那么这条路径仍然是无效的
	- 在这个问题中，你只需要将所有可能的路径（包括不同中转次数的路径）加入优先队列 `h`，然后在弹出时判断是否满足中转次数的限制即可。你不需要更新 `dis[y]`，因为 `dis[y]` 的作用在这里被弱化了。
```python
g = [[] for _ in range(n)]
for u,v,w in edges:
	g[u].append([v,w])
	g[v].append([u,w])
dis = [inf]*n # 从0到达各个点的距离
dis[0] = 0 

# 用heap来优化
h = [[0,0,k+1]]
while h:
	dx,x,step = heappop(h)
	if step<=0:
		break
	for y,w in g[x]:
		if dx+w<dis[y]:
			# dis[y] = dx+w
			heappush(h, [dx+w, y, step-1])

for i,value in enumerate(dis):
	if value is inf:
		dis[i] = -1
return dis
```

# [787. K 站中转内最便宜的航班](https://leetcode.cn/problems/cheapest-flights-within-k-stops/)
带状态的dijkstra (超时)
```python
class Solution:
    def findCheapestPrice(self, n: int, flights: List[List[int]], src: int, dst: int, k: int) -> int:
        g = defaultdict(list)
        for x, y, w in flights:
            g[x].append((y, w))
        dist = [float('inf')] * n
        dist[src] = 0
        
        h = [(0, src, k + 1)]
        while h:
            d, x, steps = heappop(h)
            if x == dst:
                return d
            if steps <= 0:
                continue
            for y, w in g[x]:
                if d + w < dist[y]:
                    heappush(h, (d + w, y, steps - 1))
        return -1
```
# [1928. 规定时间内到达终点的最小花费](https://leetcode.cn/problems/minimum-cost-to-reach-destination-in-time/)
- 双向图
- 需要维护一个二维的 `dist` 第一维是节点，第二维是时间
```python
class Solution:
    def minCost(self, maxTime: int, edges: List[List[int]], passingFees: List[int]) -> int:
        n = len(passingFees)
        g = defaultdict(list)
        for x, y, w in edges:
            g[x].append((y, w))
            g[y].append((x, w))
        
        # dist 需要设置为二维： 第一维是节点，第二维是时间
        dist = [[float('inf')] * (maxTime + 1) for _ in range(n)]
        dist[0][0] = passingFees[0]

        h = [(passingFees[0], 0, 0)]
        while h:
            cost, x, time = heappop(h)
            if x == n - 1:
                continue
            for y, w in g[x]:
                if time + w <= maxTime and cost + passingFees[y] < dist[y][time + w]:
                    dist[y][time + w] = cost + passingFees[y]
                    heappush(h, (cost + passingFees[y], y, time + w))
        return min(dist[n - 1]) if min(dist[n - 1]) != float('inf') else -1
```
