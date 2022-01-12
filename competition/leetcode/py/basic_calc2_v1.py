class Solution:
    def calculate(self, s: str) -> int:
        s = s.replace( " " , "") # remove space
        operands = []
        ops = []
        
        buffer = []
        priority = {'+':1, '-':1, '*':2, '/':2}
        
        def perform_op(l, r, op):
            # if op == '-' and r < 0: r *= -1
                
            if op == '+':
                return l + r
            elif op == '-':
                return l-r
            elif op == '*':
                return l*r
            elif op == '/':
                return l // r
        
        
        def decode(c):
            op = None
            operand = None
            if c.isnumeric():
                buffer.append(c)
            else:
                op = c
                operand = int(''.join(buffer))
                buffer.clear()
        
            return op, operand
        
        def is_perform_op(curr_op, op_top):
            if curr_op == ' ': return True
            if op_top:
                if priority[curr_op] <= priority[op_top]:
                    return True
                else: return False
            
            return False
        
        def push_operand(n):
            if n < 0:
                ops.append('-')
                operands.append(abs(n))
            else:
                ops.append('+')
                operands.append(abs(n))
        
        def pop_op():
            return None if len(ops) == 0 else ops.pop()
        
        def pop_operand(): 
            return deduce_operand(operands.pop(), pop_op())
            
        
        def deduce_operand(n, sign):
            # print(sign, n)
            if sign is None or sign == '+': return n
            else: return -n
                
        s += ' '
        for c in s:
            op, operand = decode(c)
            if op: 
                # if op found, be ready to perform an operation 
                # or push into stack based on precendence
                op_top = None if len(ops) == 0 else ops[-1]
                op_flag = op_top in ['*', '/']
                if op_flag:
                    ops.pop()
                    l = operands.pop()
                    result = perform_op(l, operand, op_top)
                    operands.append(result)
                    if op != ' ': ops.append(op)
                else:
                    operands.append(operand)
                    if op != ' ': ops.append(op)
                            

        # print(operands, ops)
        while len(operands) > 1:
            r = pop_operand()
            l = pop_operand() 
            result = perform_op(l, r, '+')
            push_operand(result)
            
        return pop_operand()