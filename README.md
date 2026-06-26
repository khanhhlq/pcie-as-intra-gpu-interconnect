# PCIe as Intra-GPU Interconnect

## Thông tin đề tài

**Tên đề tài:** PCIe as Intra-GPU Interconnect: Nghiên cứu Bottleneck của PCIe trong hệ thống đa GPU và mô phỏng trên Vivado

**Môn học:** Kiến trúc Máy tính và Vi xử lý  
**Mã học phần:** MPCA333364  
**Lớp học phần:** 252MPCA333364_01  
**Nhóm:** 02  
**Giảng viên hướng dẫn:** PGS.TS. Võ Minh Huân  

## Link thuyết trình

Video báo cáo nhóm:  
https://youtu.be/NPu2KXvkF3E

## Mục tiêu đề tài

Đề tài tập trung nghiên cứu vai trò của PCI Express (PCIe) trong hệ thống đa GPU, đặc biệt là hiện tượng bottleneck khi nhiều GPU cùng truyền dữ liệu qua một tài nguyên kết nối dùng chung.

Các mục tiêu chính:

- Tìm hiểu tổng quan về PCIe và kiến trúc kết nối trong hệ thống máy tính.
- Phân tích sự khác nhau giữa PCI và PCIe.
- Nghiên cứu nguyên nhân gây bottleneck trong hệ thống đa GPU.
- Xây dựng mô hình mô phỏng PCIe Intra-GPU Interconnect bằng Verilog HDL.
- Mô phỏng hệ thống trên Vivado.
- Đánh giá hiệu năng thông qua các chỉ số throughput, stall counter và FIFO occupancy.

## Kiến trúc mô phỏng

Mô hình mô phỏng gồm các thành phần chính:

```text
GPU0
GPU1
GPU2  --->  PCIe Switch  --->  FIFO Buffer  --->  GPU Receiver
GPU3