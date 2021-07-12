
class Solution:
    def decodeString(self, s: str) -> str:
        stack = []

        index = 0
        while not (index >= len(s)):
            curr_ch = s[index]
            # print(curr_ch)

            # process first char
            if curr_ch.isalpha():
                stack.append(curr_ch)

            elif curr_ch.isdigit():
                stack.append(curr_ch)

            elif curr_ch == '[':
                stack.append(curr_ch)
            
            elif curr_ch == ']':
                # pop till the number and deduce the string and push again to stack
                # print(stack)
                internal_str = ""
                while len(stack) != 0 and stack[-1] != '[':
                    internal_str = stack.pop() + internal_str

                if stack[-1] == '[': stack.pop()

                # now pop out the number
                number = ""
                while len(stack) != 0 and stack[-1] != ']' and stack[-1] != '[' and not stack[-1].isalpha():
                    number = stack.pop() + number
                
                number = int(number)
                string = ''.join([internal_str] * number)
                stack.append(string)

            else:
                assert False

            index += 1

        # pop everything out of stack
        internal_str = ""
        while not (len(stack) == 0):
            internal_str = stack.pop() + internal_str
        
        return internal_str

# if __name__ == "__main__":
#     s = Solution()
#     print(s.decodeString("3[z]2[2[y]pq4[2[jk]e1[f]]]ef"))
