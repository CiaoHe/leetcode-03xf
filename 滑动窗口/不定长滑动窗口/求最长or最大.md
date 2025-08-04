#  [3. 无重复数字的最长子串](https://leetcode.cn/problems/longest-substring-without-repeating-characters/)
方法一：用cnter来维护出现的char的次数，一旦发现当前右边界的char出现的次数>1, 立刻收缩左边届
```python
class Solution:
    def lengthOfLongestSubstring(self, s: str) -> int:
        n = len(s)
        l = 0
        cnt = Counter()
        ans = 1
        for r,x in enumerate(s):
            cnt[x]+=1
            # 不断收缩l
            while cnt[x]>1:
                cnt[s[l]] -= 1
                l += 1
            ans = max(r-l+1, ans)
        return ans
```
方法二：用hash来维护每个char出现的位置，一旦发现当前右边界出现在hash中，立刻收缩左边届到`max(l, d[char]+1)`
```python
class Solution:
    def lengthOfLongestSubstring(self, s: str) -> int:
        n = len(s)
        d = dict()
        res = 0
        l = 0 # left bound
        for i,c in enumerate(s):
            if c in d:
                l = max(l,d[c]+1)
            d[c] = i
            res = max(i-l+1, res)
        return res
```

# [1695. 删除子数组的最大得分](https://leetcode.cn/problems/maximum-erasure-value/)
给你一个正整数数组 `nums` ，请你从中删除一个含有 **若干不同元素** 的子数组**。**删除子数组的 **得分** 就是子数组各元素之 **和** 。

返回 **只删除一个** 子数组可获得的 **最大得分** _。_

如果数组 `b` 是数组 `a` 的一个连续子序列，即如果它等于 `a[l],a[l+1],...,a[r]` ，那么它就是 `a` 的一个子数组。


和#3一个意思
```python
class Solution:
    def maximumUniqueSubarray(self, nums: List[int]) -> int:
        n = len(nums)
        left = 0
        res = 0
        current_sum = 0
        seen = set()
        
        for right in range(n):
            while nums[right] in seen:
                seen.remove(nums[left])
                current_sum -= nums[left]
                left += 1
            seen.add(nums[right])
            current_sum += nums[right]
            res = max(res, current_sum)
            
        return res
```
# [3297. 统计重新排列后包含另一个字符串的子字符串数目 I](https://leetcode.cn/problems/count-substrings-that-can-be-rearranged-to-contain-a-string-i/)
参考模版题目[[3. 无重复数字的最长子串](https://leetcode.cn/problems/longest-substring-without-repeating-characters/)](#[3.%20无重复数字的最长子串](https%20//leetcode.cn/problems/longest-substring-without-repeating-characters/))
- 用right向前滑动
- 用left来收缩左边界，同时left的位置也标志着以 `right` 为右边界合法的子串数目
```python
class Solution:
    def validSubstringCount(self, word1: str, word2: str) -> int:
        m,n = len(word1), len(word2)
        if m < n:
            return 0
        cnt1 = Counter()
        cnt2 = Counter(word2)
        
        res = 0
        left = 0
        for right, c in enumerate(word1):
            cnt1[c] += 1
            while cnt1 >= cnt2:
                cnt1[word1[left]] -= 1
                left += 1
            res += left
        return res
```
# [2106. 摘水果](https://leetcode.cn/problems/maximum-fruits-harvested-after-at-most-k-steps/)
在一个无限的 x 坐标轴上，有许多水果分布在其中某些位置。给你一个二维整数数组 `fruits` ，其中 `fruits[i] = [positioni, amounti]` 表示共有 `amounti` 个水果放置在 `positioni` 上。`fruits` 已经按 `positioni` **升序排列** ，每个 `positioni` **互不相同** 。

另给你两个整数 `startPos` 和 `k` 。最初，你位于 `startPos` 。从任何位置，你可以选择 **向左或者向右** 走。在 x 轴上每移动 **一个单位** ，就记作 **一步** 。你总共可以走 **最多** `k` 步。你每达到一个位置，都会摘掉全部的水果，水果也将从该位置消失（不会再生）。

返回你可以摘到水果的 **最大总数** 。

1. ​**​摘水果的路线​**​：无论你怎么走，最终摘水果的位置一定是一个连续的区间 [l, r]
2. ​**​步数计算​**​：从 startPos 到这个区间 [l, r] 的步数取决于：
    - 如果 startPos 在区间左边（startPos ≤ l）：直接向右走到 r，步数 = r - startPos
    - 如果 startPos 在区间右边（startPos ≥ r）：直接向左走到 l，步数 = startPos - l
    - 如果 startPos 在区间中间（l < startPos < r）：
        - 可以左→右：先向左到 l，再向右到 r，步数 = (startPos - l) + (r - l)
        - 可以右→左：先向右到 r，再向左到 l，步数 = (r - startPos) + (r - l)
        - 取两者中较小的：步数 = (r - l) + min(startPos - l, r - startPos)
解决方法：
3. 使用滑动窗口（双指针）找出所有可能的 [l, r] 区间
4. 对于每个区间，计算从 startPos 到这个区间的最小步数
5. 如果步数 ≤ k，则计算这个区间的水果总数，并更新最大值

```python
class Solution:
    def maxTotalFruits(self, fruits: List[List[int]], startPos: int, k: int) -> int:
        # 要么从左到右然后转头，要么从右到左然后转头; 要么就朝着一个方向走完
        ans = 0
        i = 0
        # 假设最后摘水果的范围是[l,r]
        s = 0
        # 我们用i,j 来代表 左边的index 和 右边的index
        for j, (pj, val) in enumerate(fruits):
            s += val
            while i<=j and pj - fruits[i][0] + min(
                abs(startPos - fruits[i][0]),
                pj - startPos
            ) > k:
                s -= fruits[i][1] # 收缩左边界
                i += 1
            ans = max(ans, s)
        return ans
```