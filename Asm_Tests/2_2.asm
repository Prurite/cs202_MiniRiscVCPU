.text
.globl main

# Main program
main:
    li a7, 5               # 假设5是读取半精度浮点数的系统调用
    ecall                  # 读取16位浮点数到a0

    # a0现在包含一个16位的半精度浮点数
    # 扩展到32位单精度浮点数
    fmv.w.x fa0, a0        # 将整数移动到浮点寄存器
    fcvt.s.h fa0, fa0      # 半精度到单精度的转换

    # 执行向上取整
    fceil.s fa0, fa0       # 向上取整

    # 将32位单精度结果转换回16位半精度
    fcvt.h.s fa1, fa0      # 单精度到半精度的转换
    fmv.x.w a0, fa1        # 将结果从浮点寄存器移动到整数寄存器

    # 输出结果
    li a7, 1               # 假设1是输出半精度浮点数的系统调用
    ecall                  # 输出a0

    # 程序结束
    li a7, 10              # 退出系统调用
    ecall                  # 执行系统调用
