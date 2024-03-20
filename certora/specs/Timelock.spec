// SPDX-License-Identifier: GPL-2.0-or-later
import "LastUpdated.spec";

definition min(uint256 x, uint256 y) returns uint256 = x < y ? x : y;

definition nextGuardianUpdateTime(uint256 currentTime) returns uint256 =
    pendingGuardian_().validAt != 0 ?
    min(pendingGuardian_().validAt, assert_uint256(currentTime + timelock())) :
    assert_uint256(currentTime + timelock());

rule guardianUpdateTime(uint256 currentTime, env e, method f, calldataarg args) {
    // Safe require as it corresponds to some time very far into the future.
    require currentTime < 2^63;
    // Safe require because it is a verified invariant.
    require isTimelockInRange();

    uint256 nextTime = nextGuardianUpdateTime(currentTime);
    address prevGuardian = guardian();

    // Assume that the guardian is already set.
    require prevGuardian != address(0);
    // Sane assumption on the current time.
    require e.block.timestamp >= currentTime;
    // Increasing nextGuardianUpdateTime with no interaction;
    assert nextGuardianUpdateTime(e.block.timestamp) >= nextTime;

    f(e, args);

    if (guardian() != prevGuardian) {
        assert e.block.timestamp >= nextTime;
    }
    if (e.block.timestamp < nextTime)  {
        assert guardian() == prevGuardian;
        // Increasing nextGuardianUpdateTime with an interaction;
        assert nextGuardianUpdateTime(e.block.timestamp) >= nextTime;
    }
    assert true;
}
