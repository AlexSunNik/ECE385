transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/Users/andyc/iCloudDrive/Desktop/UIUC/2019\ Fall/ECE\ 385/Labs/Codes/ECE-385/Lab4/bit-serial-adders {C:/Users/andyc/iCloudDrive/Desktop/UIUC/2019 Fall/ECE 385/Labs/Codes/ECE-385/Lab4/bit-serial-adders/fulladder.sv}
vlog -sv -work work +incdir+C:/Users/andyc/iCloudDrive/Desktop/UIUC/2019\ Fall/ECE\ 385/Labs/Codes/ECE-385/Lab4/bit-serial-adders {C:/Users/andyc/iCloudDrive/Desktop/UIUC/2019 Fall/ECE 385/Labs/Codes/ECE-385/Lab4/bit-serial-adders/HexDriver.sv}
vlog -sv -work work +incdir+C:/Users/andyc/iCloudDrive/Desktop/UIUC/2019\ Fall/ECE\ 385/Labs/Codes/ECE-385/Lab4/bit-serial-adders {C:/Users/andyc/iCloudDrive/Desktop/UIUC/2019 Fall/ECE 385/Labs/Codes/ECE-385/Lab4/bit-serial-adders/CSAadder.sv}
vlog -sv -work work +incdir+C:/Users/andyc/iCloudDrive/Desktop/UIUC/2019\ Fall/ECE\ 385/Labs/Codes/ECE-385/Lab4/bit-serial-adders {C:/Users/andyc/iCloudDrive/Desktop/UIUC/2019 Fall/ECE 385/Labs/Codes/ECE-385/Lab4/bit-serial-adders/CRAadder.sv}
vlog -sv -work work +incdir+C:/Users/andyc/iCloudDrive/Desktop/UIUC/2019\ Fall/ECE\ 385/Labs/Codes/ECE-385/Lab4/bit-serial-adders {C:/Users/andyc/iCloudDrive/Desktop/UIUC/2019 Fall/ECE 385/Labs/Codes/ECE-385/Lab4/bit-serial-adders/carry_select_adder.sv}
vlog -sv -work work +incdir+C:/Users/andyc/iCloudDrive/Desktop/UIUC/2019\ Fall/ECE\ 385/Labs/Codes/ECE-385/Lab4/bit-serial-adders {C:/Users/andyc/iCloudDrive/Desktop/UIUC/2019 Fall/ECE 385/Labs/Codes/ECE-385/Lab4/bit-serial-adders/lab4_adders_toplevel.sv}

vlog -sv -work work +incdir+C:/Users/andyc/iCloudDrive/Desktop/UIUC/2019\ Fall/ECE\ 385/Labs/Codes/ECE-385/Lab4/bit-serial-adders {C:/Users/andyc/iCloudDrive/Desktop/UIUC/2019 Fall/ECE 385/Labs/Codes/ECE-385/Lab4/bit-serial-adders/testbench.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  testbench

add wave *
view structure
view signals
run 1000 ns
