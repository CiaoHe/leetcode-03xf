# 和Dijkstra的对比
vs [Dijkstra-单源最短路径](Dijkstra-单源最短路径.md)
#### **Bellman-Ford 算法**

- **思想**：通过 **松弛操作**（relaxation）逐步优化从源节点到所有其他节点的最短路径。
- **过程**：
    1. 初始化所有节点的距离为无穷大，源节点的距离为 0。
    2. 对所有边进行多次松弛操作，直到所有节点的最短路径不再变化。        
    3. 如果图中存在负权环，算法可以检测到并返回错误。
#### **Dijkstra 算法**
- **思想**：通过贪心策略，每次选择当前距离最短的节点，并更新其邻居的距离。
- **过程**：
    1. 初始化所有节点的距离为无穷大，源节点的距离为 0。
    2. 使用优先队列（最小堆）选择当前距离最短的节点。
    3. 对选中的节点进行松弛操作，更新其邻居的距离。
    4. 重复上述过程，直到所有节点都被处理。

| 特性        | Bellman-Ford 算法 | Dijkstra 算法  |
| --------- | --------------- | ------------ |
| **时间复杂度** | O(VE)           | O((V+E)logV) |
| **负权边处理** | 支持              | 不支持          |
| **负权环检测** | 支持              | 不支持          |
| **适用场景**  | 可能存在负权边或负权环的图   | 所有边权重为非负数的图  |
| **实现复杂度** | 简单              | 稍微复杂         |
| **性能**    | 较慢              | 较快           |
# [787. K 站中转内最便宜的航班](https://leetcode.cn/problems/cheapest-flights-within-k-stops/)
Bellman-Ford 会更light
```python
class Solution:
    def findCheapestPrice(self, n: int, flights: List[List[int]], src: int, dst: int, k: int) -> int:
        dist = [float('inf')] * n # 从src出发到i的最小花费
        dist[src] = 0 
        for _ in range(k + 1):
            tmp = dist[:]
            for x, y, w in flights:
                tmp[y] = min(tmp[y], dist[x] + w) # 如果从x到y有航班，则更新从src到y的最小花费
            dist = tmp
        return dist[dst] if dist[dst] != float('inf') else -1
```
Dijkstra参照[[787. K 站中转内最便宜的航班](https://leetcode.cn/problems/cheapest-flights-within-k-stops/)](Dijkstra-单源最短路径.md#[787.%20K%20站中转内最便宜的航班](https%20//leetcode.cn/problems/cheapest-flights-within-k-stops/)) 但是会卡时间（超时）