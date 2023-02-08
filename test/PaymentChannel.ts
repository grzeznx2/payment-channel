import { ethers } from "hardhat";

describe("PaymentChannel", function () {
  async function deployOneYearLockFixture() {
    const [owner, otherAccount] = await ethers.getSigners();

    const PaymentChannel = await ethers.getContractFactory("PaymentChannel");
    const paymentChannel = await PaymentChannel.deploy();

    return { paymentChannel, owner, otherAccount };
  }

  describe("Deployment", function () {
  });
});
