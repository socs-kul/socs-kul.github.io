.data
    result: .space 8
    i:      .dword 6

.text
.globl main
func:
    addi	sp,sp,-48
    sw	s0,44(sp)
    addi	s0,sp,48
    sw	a0,-20(s0)
    sw	a1,-24(s0)
    sw	a2,-32(s0)
    sw	a3,-28(s0)
    sw	a4,-40(s0)
    sw	a5,-36(s0)
    sw	a6,-48(s0)
    sw	a7,-44(s0)
    lw	a4,-20(s0)
    lw	a5,-24(s0)
    add	a5,a4,a5
    mv	t1,a5
    srai	a5,a5,0x1f
    mv	t2,a5
    lw	a2,-32(s0)
    lw	a3,-28(s0)
    add	a4,t1,a2
    mv	a1,a4
    sltu	a1,a1,t1
    add	a5,t2,a3
    add	a3,a1,a5
    mv	a5,a3
    mv	a2,a4
    mv	a3,a5
    lw	a0,-40(s0)
    lw	a1,-36(s0)
    add	a4,a2,a0
    mv	a6,a4
    sltu	a6,a6,a2
    add	a5,a3,a1
    add	a3,a6,a5
    mv	a5,a3
    mv	a2,a4
    mv	a3,a5
    lw	a0,-48(s0)
    lw	a1,-44(s0)
    add	a4,a2,a0
    mv	a6,a4
    sltu	a6,a6,a2
    add	a5,a3,a1
    add	a3,a6,a5
    mv	a5,a3
    mv	a2,a4
    mv	a3,a5
    lw	a5,0(s0)
    lw	a0,0(a5)
    lw	a1,4(a5)
    add	a4,a2,a0
    mv	a6,a4
    sltu	a6,a6,a2
    add	a5,a3,a1
    add	a3,a6,a5
    mv	a5,a3
    mv	a0,a4
    mv	a1,a5
    lw	s0,44(sp)
    addi	sp,sp,48
    ret

main:
    li a0, 1
    li a1, 2

    # c = a3 (high order bits) | a2 (low order bits)
    li a2, 3
    li a3, 0

    # d = a5 | a4
    li a4, 4
    li a5, 0

    # e = a6 | a5
    li a6, 5
    li a7, 0

    # t0 = &i
    la t0, i

    # push t0 (&i)
    addi sp, sp, -4
    sw   t0, 0(sp)

    # result = func(....)
    jal func
    la  t0, result
    sw  a0, 0(t0)
    sw  a1, 4(t0)
    # See https://godbolt.org/#z:OYLghAFBqd5TKALEBjA9gEwKYFFMCWALugE4A0BIEAZgQDbYB2AhgLbYgDkAjF%2BTXRMiAZVQtGIHgBYBQogFUAztgAKAD24AGfgCsp5eiyahUAUgBMAIUtXyKxqiIEh1ZpgDC6egFc2TA3cAGQImbAA5PwAjbFIQC3IAB3QlYhcmL19/A2TU5yEQsMi2GLiEh2wndJEiFlIiTL8AnntsR3ymGrqiQojo2Pj7WvrG7JalYZ7QvpKBiwBKe3QfUlROLksAZlDUXxwAajNNjwA3SpJSI9wzLQBBG9uT9AJMfcx0AH0ldA4PgHcyABrCChIjzI42O4PJ4vfaJUjoNZKJQfYjYNhKCAYJgTfYTTAgEBnJxkI4eUFXSwANn2xPmhwA7JDbvtWfsWD4SHiAF6HTYAEVplQAdKludgIODNsy2ftBKQIPjCWLsB8iPsCHzBVoIRq%2BR4ebqCLZbPSzEyHrLZe8vj9VQDSMDiWYAKxWY0u/lSmVs838h5%2Bh5cRb0bgu/gBLg6cjobgeE3WPHLVbYQ4WTZ8chEbTBxaAkAurSGbjSfhsAtFyPR2NcfhKEBF7NR4PkOCwFAYHD4YhkSjUOiMVgcbiZwTCMQSTgyOTCZRqTTN8j6BJGExoBN2CpVVwQdyjAIWFrBabFUogBlJFJpIT7%2BItXLXpi9U8DC9bjpdEbeJp31rtaqTM%2B/RxG%2Bky3oeQzdEBswgYs3wrGs3BbDseypmSxIXJSUJ3DCrw2t8vwOsCoLegGOHPK88KItgyKokQ6KYtiuJKkS5ykscFKbNcFg0nSjI%2Bqy8oQByXJomw%2BwgEKqBmhadxWmy%2BF2v8QIgvRbCkXJvoMv6ULaUGIZhhGOYxnGG5JghaHphY/BNjo8yLEg2AsDgcSSsWXCluQ5aFuQVb8DWdYNlmOb2eQ%2BbSC6wpUgAnDw0VaFSWhaC6FiHtFmzuZsRmLgFwXNosbbIGgPyJAwsR9liJVlXEuzGMAPCbFoLQDvRpD1hAUTGVEoR1AAniO/AYGwHDCAA8kw9D9YuOBsHVkjTQQpDnAQZz1ou2DqJUnLrJmoJtMZ9AEFEpB9V4ODGUQpAEOWvAtjQRjAEoABqBDYH8o2JMwA0zqI4iSNOY6KCoGjGfoLSrqYG6GEd9aQIs6CJB0a0ALSjVlf7LTue7fmM5DHkUwE5FeHS3vexPpNBZ7jG0mOdGBOPNBj2501BJ6E%2BM9NZIzEyswTMFSHByaIS0l3YDtLahlw4a%2BcZNbqAAHFSyNUtI%2By1SY%2BwNcKWjCjw%2BwQPG1i2OQ%2BzdhcaYZibXhsKVjCkBbPDzDZIWth2VV2xVQ22wM6v1Y1zUMK17WdYu3WsKQU2ZkNI1EONk3GTNc3rNGhBLVUq3GRtW30d9e2S9Gh3HadWDJzZV03Xwiz3Swj0vW9H1fbdP0Tv9siA3OIOLsuhh1euRvWNDUSw25CNI9wqPo%2B%2B6RuEwngM4Es%2BUwMZN5OkpOXqvBRs/z1P/kIn4NPPu%2B0wfS9xBz3Trzz9RnwLSwWYMoviwZUvZdW3AK0rKtqxDmubNrut9aGxsAPU2hBzZbASPsa23t7aQKdnlOyrsQCEBoDQCqgMW5TjbvIDuC4C5IHrODQhqCaBEF6p9IKpBCGDGoUoUh5DKFaBftLPyJkuD8gIGg/Ydc/ixH2J/ZWqtfZ/wAXrE4SgBGKyET/OqoidaZlsrmcgjlnIDDcvmF00hhSNXllodK0VorSAZAyPRDIqTuU8uWHgSUZY5W4IFBISjQqS2snY9%2BtZEHKLOG1ae0ggA

    # pop
    addi sp, sp, 4
