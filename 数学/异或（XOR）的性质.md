异或（⊕）运算有以下重要性质：
1. ​**​交换律​**​：a⊕b=b⊕a
2. ​**​结合律​**​：(a⊕b)⊕c=a⊕(b⊕c)
3. ​**​自反性​**​：a⊕a=0
4. ​**​与 0 的异或​**​：a⊕0=a
5. ​**​可逆性​**​：如果 a⊕b=c，那么 a=b⊕c 和 b=a⊕c

# [2683. 相邻值的按位异或](https://leetcode.cn/problems/neighboring-bitwise-xor/)
假设：
- original=[a0​,a1​,a2​,…,an−1​]
- derived=[d0​,d1​,d2​,…,dn−1​]

根据定义：
$$ d_{0} = a_{0} \oplus a_{1} $$
$$ d_{1} = a_{1} \oplus a_{2} $$
$$ \vdots $$
$$ d_{n-2} = a_{n-2} \oplus a_{n-1} $$
$$ d_{n-1} = a_{n-1} \oplus a_{0} $$
$$ a_{1} = a_{0} \oplus d_{0} $$

$$ a_{2} = a_{1} \oplus d_{1} = a_{0} \oplus d_{0} \oplus d_{1} $$

$$ a_{3} = a_{2} \oplus d_{2} = a_{0} \oplus d_{0} \oplus d_{1} \oplus d_{2} $$

$$ \vdots $$

$$ a_{n-1} = a_{0} \oplus d_{0} \oplus d_{1} \oplus \cdots \oplus d_{n-2} $$
最后需要检查$a_0$ xor $a_{n-1}$ == $d_{n-1}$
那么我们把$a_{n-1}$ 展开可以得到  (a0​⊕d0​⊕d1​⊕⋯⊕dn−2​)⊕a0​=dn−1​
根据xor的性质可以消除掉$a_0$ (交换律+自反)
同时可以两边xor上 $d_{n-1}$, 最后需要判别 d0​⊕d1​⊕⋯⊕dn−1​=0

```python
class Solution:
    def doesValidArrayExist(self, derived: List[int]) -> bool:
        return reduce(xor, derived) == 0
```

# [3514. 不同 XOR 三元组的数目 II](https://leetcode.cn/problems/number-of-unique-xor-triplets-ii/)
给你一个整数数组 `nums` 。
**XOR 三元组** 定义为三个元素的异或值 `nums[i] XOR nums[j] XOR nums[k]`，其中 `i <= j <= k`。
返回所有可能三元组 `(i, j, k)` 中 **不同** 的 XOR 值的数量。

```python
class Solution:
    def uniqueXorTriplets(self, nums: List[int]) -> int:
        nums = list(set(nums))
        # 我们先获得任何pair的异或结果
        # 记住追加上0，因为我们可以同时选择一个数两次
        st = {x^y for x,y in combinations(nums, 2)} | {0}
        ans = set()
        for z in nums:
            for xy in st:
                ans.add(xy^z)
        return len(ans)
```

# [3702. 按位异或非零的最长子序列](https://leetcode.cn/problems/longest-subsequence-with-non-zero-bitwise-xor/)
给你一个整数数组 `nums`。

返回 `nums` 中 **按位异或**（XOR）计算结果 **非零** 的 **最长子序列** 的长度。如果不存在这样的 **子序列** ，返回 0 。

**子序列** 是一个 **非空** 数组，可以通过从原数组中删除一些或不删除任何元素（不改变剩余元素的顺序）派生而来。

```python
class Solution:
    def longestSubsequence(self, nums: List[int]) -> int:
        # 1. 如果全为 0，无法构成非 0 异或和
        if all(x == 0 for x in nums):
            return 0

        # 2. 如果整体异或和不为 0，答案就是 n；否则为 n - 1
        total_xor = 0
        for x in nums:
            total_xor ^= x

        return len(nums) if total_xor != 0 else len(nums) - 1
```