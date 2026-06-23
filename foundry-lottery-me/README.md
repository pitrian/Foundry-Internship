# Provably Random Raffle Contracts (Hợp đồng Xổ số Ngẫu nhiên Minh bạch)

## 📝 Giới thiệu
Dự án này tập trung vào việc xây dựng một hệ thống xổ số (raffle) hoàn toàn phi tập trung và tự vận hành trên blockchain. Mục tiêu cốt lõi là tạo ra một trò chơi có tính công bằng tuyệt đối và có thể chứng minh được sự ngẫu nhiên thông qua công nghệ Web3.

---

## 🎯 Mục tiêu Dự án
Hợp đồng thông minh được thiết kế để thực hiện các chức năng tự động và phi tập trung sau:
* **Người chơi tham gia:** Người dùng có thể tham gia rút thăm bằng cách trả phí mua vé (`entranceFee`). Toàn bộ số tiền này sẽ được tích lũy vào quỹ giải thưởng dành cho người chiến thắng.
* **Tự động quay thưởng:** Hệ thống tự động chọn người chiến thắng theo lập trình sẵn sau một khoảng thời gian nhất định mà không cần bất kỳ sự can thiệp thủ công nào của con người.
* **Tính ngẫu nhiên minh bạch:** Sử dụng **Chainlink VRF (Verifiable Random Function)** để tạo ra số ngẫu nhiên không thể thao túng trên chuỗi (on-chain).
* **Tự động hóa hoàn toàn:** Tích hợp **Chainlink Automation** để liên tục theo dõi điều kiện và kích hoạt việc rút thăm định kỳ.

---

## 🛠 Công nghệ Sử dụng
* **Ngôn ngữ:** Solidity
* **Framework phát triển:** Foundry (bao gồm `Forge`, `Cast`, `Anvil` và `Script`)
* **Oracle Services:**
    * **Chainlink VRF v2.5:** Đảm bảo tính ngẫu nhiên minh bạch, có thể xác thực.
    * **Chainlink Automation:** Kích hoạt các hàm của hợp đồng tự động dựa trên thời gian và điều kiện cấu hình trước.

---

## ⚡ Đặc điểm Kỹ thuật Nổi bật
Dự án áp dụng các tiêu chuẩn lập trình nâng cao (Senior-level) nhằm đảm bảo tối đa tính bảo mật và tối ưu hiệu năng:

* **Mô hình CEI (Checks-Effects-Interactions):** Sắp xếp thứ tự các thao tác trong hàm một cách nghiêm ngặt để chống lại các cuộc tấn công tái nhập (**Reentrancy Attacks**).
* **Quản lý trạng thái bằng Enum:** Sử dụng `RaffleState` (`OPEN`, `CALCULATING`) để kiểm soát chặt chẽ luồng nghiệp vụ, ví dụ: chặn người chơi mua vé khi đang trong quá trình quay thưởng.
* **Tối ưu hóa Gas:** Thay vì sử dụng chuỗi `require` dài gây tốn gas, dự án áp dụng **Custom Errors** giúp tiết kiệm chi phí giao dịch đáng kể cho người dùng.
* **Thiết kế linh hoạt:** Tích hợp `HelperConfig` để tự động điều chỉnh tham số theo từng môi trường mạng khác nhau (`Anvil` local, `Sepolia` testnet) mà không cần chỉnh sửa trực tiếp vào mã nguồn chính.

---

## 📂 Cấu trúc Dự án
```text
├── src/
│   └── Raffle.sol                # Logic chính của hợp đồng xổ số
├── script/
│   ├── DeployRaffle.s.sol        # Kịch bản triển khai hợp đồng (Deployment script)
│   ├── HelperConfig.s.sol        # Quản lý cấu hình các tham số mạng khác nhau
│   └── Interactions.s.sol        # Tự động hóa tạo subscription, nạp tiền và thêm consumer cho Chainlink VRF
└── test/                         # Bộ test toàn diện bao gồm Unit test, Integration test và Fuzz testing
```

---

## 💻 Hướng dẫn Sử dụng (Lệnh Foundry)

### 1. Cài đặt các thư viện phụ thuộc
```bash
make install # Hoặc: forge install
```

### 2. Biên dịch hợp đồng
```bash
make build   # Hoặc: forge build
```

### 3. Kiểm thử (Testing)
*Hệ thống kiểm thử bao gồm việc mô phỏng Chainlink bằng các contract Mocks trên mạng nội bộ (Local).*

* **Chạy toàn bộ bộ test:**
    ```bash
    make test
    ```
* **Kiểm tra trên môi trường Fork thực tế từ mạng Sepolia:**
    ```bash
    forge test --fork-url $SEPOLIA_RPC_URL
    ```

### 4. Triển khai (Deployment)
Sử dụng `Makefile` để rút gọn các lệnh triển khai phức tạp lên mạng thử nghiệm:
```bash
make deploy ARGS="--network sepolia"
```

---

## 🛡 Bảo mật & Thực tiễn Tốt nhất (Best Practices)
> ✨ **Tiêu chuẩn áp dụng:**
> * Sử dụng **NatSpec** để viết tài liệu hướng dẫn chuyên nghiệp ngay trong mã nguồn, giúp các nhà phát triển và kiểm toán viên (auditors) dễ dàng tiếp cận.
> * Sử dụng từ khóa `immutable` cho các biến tham số cố định nhằm tối ưu hóa bộ nhớ và tiết kiệm gas.
> * Thực hiện **Fuzz Testing** thông qua Foundry để kiểm tra tính ổn định, đảm bảo hợp đồng hoạt động an toàn trước hàng nghìn đầu vào ngẫu nhiên và các trường hợp biên (edge cases).