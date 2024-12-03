注意：在无向图中起作用
```python
g = [[inf]*n for _ in range(n)]
for u,v,w in roads:
	g[u][v] = w
	g[v][u] = w
for i in range(n):
	g[i][i] = 0

# 枚举中间节点
for k in range(n):
	for i in range(n):
		for j in range(n):
			if g[i][k] + g[k][j] < g[i][j]:
				g[i][j] = g[i][k] + g[k][j]
```