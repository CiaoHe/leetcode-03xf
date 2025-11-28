非常好的解析 [Z 函数（扩展 KMP） - OI Wiki](https://oi-wiki.org/string/z-func/)
# 定义

For a string `s` (length is `n`), we define $z[i]$ as the `s` 和 `s[i,n-1] `(以`s[i]`为开头的后缀) 最长公共前缀(LCP) 的长度 
- `z[0] = 0` 
> [!和KMP 中 `pi` 的区别]
> 1. `pi[i]` 表示 `s[:i]` (以`s[i]`结尾的前缀) 和 `s`后缀匹配的长度
> 2. `z[i]` 表示 LCP (`s[i:]`, `s`)
## naive implementation
```python fold
def z_function_trivial(s:str)->List[int]:
	n = len(s)
	z = [0] * n
	for i in range(1,n):
		while i+z[i]<n and s[z[i]] == s[i+z[i]]:
			z[i]+=1
	return z
```
## linear implementation
- 关键在于使用AC的思想去寻找限制条件下的状态转移函数，从而来加速计算
- 在计算`z[i]` 的过程中我们会利用已经计算好的 `z[0]`...`z[i-1]`
- 对于 `i`, 我们把 `[i, i+z[i]-1]` 称作 `i` 的 z-box  (匹配段)
- 算法过程中，我们维护 右端点rightmost 的 z-box, note as `[box_l, box_r]` 
	- init as `box_l=0, box_r=0`
	- 计算过程中保证 `box_l<=i`
- when compute `z[i]`
	- if `i<=box_r`, 那么根据定义我们有 `s[i, box_r] = s[i-box_l, box_r-box_l]` (z函数的定义)
		- then, `z[i] = min(z[i-box_l], box_r-i+1)`
	- 然后我们试图扩展 当前的这个 z-box (右端点rightmost)
		- 搞起来 `while i+z[i]<n and s[z[i]] == s[i+z[i]]: z[i]+=1` 这一套
```python fold
def z_function(s:str)->int:
	# z(i): 后缀s[i:]与s的最长公共前缀长度
	n = len(s)
	z = [0] * n
	box_l, box_r = 0, 0 # box_l, box_r: 用于标记 当前已知的 非零z值的 最右区间
	for i in range(1, n):
		if i <= box_r:
			z[i] = min(box_r - i + 1, z[i-box_l])
		# 试图扩展 当前已知的 非零z值的 最右区间
		while i + z[i] < n and s[i+z[i]] == s[z[i]]:
			box_l, box_r = i, i + z[i] - 1
			z[i] += 1
	return z
```
# 使用
为了避免混淆，我们将 `t` 称作 **文本**，将 `p` 称作 **模式**。所给出的问题是：寻找在文本 `t` 中模式 `p` 的所有出现（occurrence）。

1. 我们构造一个新的字符串 `s = p + o + t`，也即我们将 `p` 和 `t` 连接在一起，但是在中间放置了一个分割字符 `o`（我们将如此选取 `o` 使得其必定不出现在 `p` 和 `t` 中）。
2. 首先计算 `s` 的 Z 函数。
3. 接下来，对于在区间 `[0,|t|-1]` 中的任意 `i`，我们考虑以 `t[i]` 为开头的后缀在 `s` 中的 Z 函数值 `k = z[i+|p|+1]`。
	1. 如果 `k = |p|`，那么我们知道有一个 `p` 的出现位于 `t` 的第 `i` 个位置，
	2. 否则没有 `p` 的出现位于 `t` 的第 `i` 个位置。
```python fold
n = len(target)
p = len(pattern)
s = pattern + '#' + target
occurs = [False] * n
for i in range(n):
	z = z_function(s)
	k = z[i+p+1]
	if k==p:
		occurs[i] = True # 出现
```

# [3292. 形成目标字符串需要的最少字符串数 II](https://leetcode.cn/problems/minimum-number-of-valid-strings-to-form-target-ii/)
主要是z函数 + [[45. 跳跃游戏 II](区间选点.md#[45.%20跳跃游戏%20II](https%20//leetcode.cn/problems/jump-game-ii/)) / [[1326. 灌溉花园的最少水龙头数目](区间选点.md#[1326.%20灌溉花园的最少水龙头数目](https%20//leetcode.cn/problems/minimum-number-of-taps-to-open-to-water-a-garden/))]
```python fold
class Solution:
    def calc_z(self, s:str)->List[int]:
        n = len(s)
        z = [0] * n
        box_l = box_r = 0 # z-box的左右端点
        for i in range(1, n):
            if i <= box_r:
                z[i] = min(box_r - i + 1, z[i - box_l])
            while i + z[i] < n and s[z[i]] == s[i + z[i]]:
                box_l, box_r = i, i + z[i]
                z[i] += 1
        return z
    
    def jump(self, max_jumps: List[int]) -> int:
        ans = 0
        cur_r = 0
        nxt_r = 0
        for i, max_jump in enumerate(max_jumps):
            nxt_r = max(nxt_r, i + max_jump)
            if i == cur_r:
                if i == nxt_r:
                    return -1
                cur_r = nxt_r
                ans += 1
        return ans
    
    def minValidStrings(self, words: List[str], target: str) -> int:
        n = len(target)
        max_jumps = [0] * n
        for word in words:
            z = self.calc_z(word + '#' + target)
            m = len(word)+1
            for i in range(n):
                max_jumps[i] = max(max_jumps[i], z[i+m])
        return self.jump(max_jumps)
```