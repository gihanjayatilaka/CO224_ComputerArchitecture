echo FILE--- 1
cat case1.txt | qemu-arm -L /usr/arm-linux-gnueabi a.out >myOut1.txt
diff myOut1.txt output1.txt 
echo FILE--- 2
cat case2.txt | qemu-arm -L /usr/arm-linux-gnueabi a.out >myOut2.txt
diff myOut2.txt output2.txt 
echo FILE--- 3
cat case3.txt | qemu-arm -L /usr/arm-linux-gnueabi a.out >myOut3.txt
diff myOut3.txt output3.txt 
echo FILE--- 4
cat case4.txt | qemu-arm -L /usr/arm-linux-gnueabi a.out >myOut4.txt
diff myOut4.txt output4.txt 
echo FILE--- 5
cat case5.txt | qemu-arm -L /usr/arm-linux-gnueabi a.out >myOut5.txt
diff myOut5.txt output5.txt 
echo FILE--- 6
cat case6.txt | qemu-arm -L /usr/arm-linux-gnueabi a.out >myOut6.txt
diff myOut6.txt output6.txt 
echo FILE--- 7
cat case7.txt | qemu-arm -L /usr/arm-linux-gnueabi a.out >myOut7.txt
diff myOut7.txt output7.txt 
echo FILE--- 8
cat case8.txt | qemu-arm -L /usr/arm-linux-gnueabi a.out >myOut8.txt
diff myOut8.txt output8.txt 
echo FILE--- 9
cat case9.txt | qemu-arm -L /usr/arm-linux-gnueabi a.out >myOut9.txt
diff myOut9.txt output9.txt 
echo FILE--- 10
cat case10.txt | qemu-arm -L /usr/arm-linux-gnueabi a.out >myOut10.txt
diff myOut10.txt output10.txt 


