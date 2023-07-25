const Token = artifacts.require("Token");

contract("Token", (accounts) => {
  let tokenInstance;

  before(async () => {
    tokenInstance = await Token.deployed();
  });

  it("should allow a user to log in and receive tokens", async () => {
    const userAddress = accounts[0];

    // Check the initial balance of the user
    const initialBalance = await tokenInstance.balanceOf(userAddress);
    assert.equal(initialBalance, 0, "Initial balance should be 0");

    // Log in the user
    await tokenInstance.logIn({ from: userAddress });

    // Check the updated balance after login
    const updatedBalance = await tokenInstance.balanceOf(userAddress);
    assert.equal(updatedBalance, 10 * (10 ** 18), "Updated balance should be 10 tokens");
  });

  it("should not allow a registered user to log in again", async () => {
    const userAddress = accounts[0];

    try {
      // Attempt to log in the user again
      await tokenInstance.logIn({ from: userAddress });
      assert.fail("Expected an error, but login was successful");
    } catch (error) {
      assert.include(
        error.message,
        "You have already registered",
        "Should throw 'You have already registered' error"
      );
    }
  });
});
