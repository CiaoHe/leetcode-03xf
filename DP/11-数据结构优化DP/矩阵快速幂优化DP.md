# [3700. 锯齿形数组的总数 II](https://leetcode.cn/problems/number-of-zigzag-arrays-ii/)
[[3699. 锯齿形数组的总数 I](https://leetcode.cn/problems/number-of-zigzag-arrays-i/)](前缀和优化DP.md#[3699.%20锯齿形数组的总数%20I](https%20//leetcode.cn/problems/number-of-zigzag-arrays-i/)) 收紧要求
给你三个整数 `n`、`l` 和 `r`。
长度为 `n` 的锯齿形数组定义如下：
- 每个元素的取值范围为 `[l, r]`。
- 任意 **两个** 相邻的元素都不相等。
- 任意 **三个** 连续的元素不能构成一个 **严格递增** 或 **严格递减** 的序列。

返回满足条件的锯齿形数组的总数。

由于答案可能很大，请将结果对 `109 + 7` 取余数。

**序列** 被称为 **严格递增** 需要满足：当且仅当每个元素都严格大于它的前一个元素（如果存在）。

**序列** 被称为 **严格递减** 需要满足，当且仅当每个元素都严格小于它的前一个元素（如果存在）。

```python
"""
注意这里我们观察到dp1[j] = dp0[k-1-j]
belike
dp0: [a, b, c, d, e]
dp1: [e, d, c, b, a]

因此我们只需要维护一个数组 f[j]=dp0[j], 这样的话dp1[t]=f[k-1-t]，就可以通过 f 来计算出 dp1 的值了。

那么原来new_dp0[j] = sum(dp1[t] for t in range(j)) 就变成了
new_f[j] = sum(f[k-1-t] for t in range(j)) = sum(f[t] for t in range(k-j, k))

所以等于 new_f = P * f, P是一个下三角矩阵

初始f1 = [1] * k, 也就是dp0[0..k-1]都是1
我们只需要求得 f_n = P^(n-1) * f1, 然后答案就是 2 * sum(f_n) % MOD
"""
class Solution:
    def zigZagArrays(self, n: int, l: int, r: int) -> int:
        MOD = 1_000_000_007
        k = r - l + 1

        def mat_mul(A, B):
            BT = list(zip(*B))
            return [
                [
                    sum(x * y for x, y in zip(row, col)) % MOD
                    for col in BT
                ]
                for row in A
            ]

        def mat_vec_mul(A, v):
            return [
                sum(x * y for x, y in zip(row, v)) % MOD
                for row in A
            ]

        # 构建一个 k*k 的下三角矩阵P
        # P[i][j] = 1 当且仅当 j >= k - i
        P = [[0] * k for _ in range(k)]
        for i in range(k):
            for j in range(k-1, k-i-1, -1):
                P[i][j] = 1

        v = [1] * k # v 是长度为 1 时的 dp0 状态。
        
        # 快速幂
        exp = n - 1
        while exp:
            if exp & 1:
                v = mat_vec_mul(P, v)

            exp >>= 1
            if exp:
                P = mat_mul(P, P)

        return 2 * sum(v) % MOD
```