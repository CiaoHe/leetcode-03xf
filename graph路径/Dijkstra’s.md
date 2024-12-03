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
	if dx>dis[x]:
		continue
	for y,w in g[x]:
		new_dis = dx+w
		if new_dis<dis[y]:
			dis[y] = new_dis
			heappush(h, [new_dis, y])
for i,value in enumerate(dis):
	if value is inf:
		dis[i] = -1
return dis
```

# [1928. 规定时间内到达终点的最小花费](https://leetcode.cn/problems/minimum-cost-to-reach-destination-in-time/)
# [743. 网络延迟时间](https://leetcode.cn/problems/network-delay-time/)
从任何一点出发（e.g., k)
```python fold
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