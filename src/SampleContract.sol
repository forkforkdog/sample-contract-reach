// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./MockERC20.sol";

contract SampleContract is MockERC20 {
    constructor() MockERC20() {
        _mint(msg.sender, 1000000000000000000000000); //msg sender will be Fuzz Contract
    }

    error SampleError(string message);

    event SampleInputGlobal1Coverage(uint256 sampleInputGlobal1);
    event SampleInputGlobal2Coverage(uint256 sampleInputGlobal2);
    event SampleInputGlobal3Coverage(uint256 sampleInputGlobal3);

    struct Struct {
        uint256 sampleInput;
        uint256 sampleInput2;
        uint256 sampleInput3;
    }

    uint256 public sampleInputGlobal1;
    uint256 public sampleInputGlobal2;
    uint256 public sampleInputGlobal3;

    // Complex state tracking for harder coverage
    uint256 public sequenceCounter;
    uint256 public lastIncrementBlock;
    uint256 public accumulatedHash;
    mapping(uint256 => bool) public reachedCheckpoints;
    uint256[] public fibonacciSequence;
    uint256 public primeAccumulator;

    bool public SETUP_CONFIG_1;
    uint256 public SETUP_CONFIG_2;
    uint8 public SETUP_CONFIG_3;

    bool public LIFECYCLE_CONFIG_1_ORACLE_FEE;
    uint256 public LIFECYCLE_CONFIG_2_MM_FEE;
    uint8 public LIFECYCLE_CONFIG_3_MIN_COLLATERAL_RATIO;

    function sampleFunction(uint256 sampleInput) public {
        sampleInputGlobal1 = sampleInput + 1;
        sampleInputGlobal2 = sampleInput + 2;
        sampleInputGlobal3 = sampleInput + 3;
    }

    function sampleFailWithRequire() public {
        sampleInputGlobal1 = sampleInputGlobal1 + 1;

        require(false, "Sample fail with require");
    }

    function sampleFailWithCustomError() public {
        sampleInputGlobal1 = sampleInputGlobal1 + 1;
        revert SampleError("Sample fail with custom error");
    }

    function sampleFailWithPanic() public {
        sampleInputGlobal1 = sampleInputGlobal1 + 1;
        uint256 zero = 1 - 1;
        uint256(1) / zero;
    }

    function sampleFailWithAssert() public {
        assert(false);
    }

    function sampleFailReturnEmptyData() public {
        //revert and return nothing
        assembly {
            revert(0, 0)
        }
    }

    function complexFunction(
        uint256 sampleInput,
        uint256 sampleInput2,
        uint256 sampleInput3,
        Struct memory sampleStruct
    ) public {
        sampleStruct.sampleInput =
            sampleStruct.sampleInput +
            sampleStruct.sampleInput2 +
            1;
    }

    function setSetupConfig1(bool setupConfig1) public {
        SETUP_CONFIG_1 = setupConfig1;
    }

    function setSetupConfig2(uint256 setupConfig2) public {
        SETUP_CONFIG_2 = setupConfig2;
    }

    function setSetupConfig3(uint8 setupConfig3) public {
        SETUP_CONFIG_3 = setupConfig3;
    }

    function setLifecycleConfig1OracleFee(
        bool lifecycleConfig1OracleFee
    ) public {
        LIFECYCLE_CONFIG_1_ORACLE_FEE = lifecycleConfig1OracleFee;
    }

    function setLifecycleConfig2MmFee(uint256 lifecycleConfig2MmFee) public {
        LIFECYCLE_CONFIG_2_MM_FEE = lifecycleConfig2MmFee;
    }

    function setLifecycleConfig3MinCollateralRatio(
        uint8 lifecycleConfig3MinCollateralRatio
    ) public {
        LIFECYCLE_CONFIG_3_MIN_COLLATERAL_RATIO = lifecycleConfig3MinCollateralRatio;
    }

    function fibonacciLength() public view returns (uint256) {
        return fibonacciSequence.length;
    }

    function incrementSampleInputGlobal1(
        uint256 incrementBy,
        uint256 seed1,
        uint256 seed2
    ) public {
        // Complex entry conditions - harder to reach
        require(incrementBy > 0, "Increment must be positive");

        // Track sequence for pattern detection
        sequenceCounter++;

        // Time-based constraints (block-based in testing)
        uint256 blockDelta = block.number - lastIncrementBlock;
        lastIncrementBlock = block.number;

        // Hash accumulation for pseudo-randomness
        accumulatedHash = uint256(
            keccak256(
                abi.encodePacked(accumulatedHash, incrementBy, seed1, seed2)
            )
        );

        // LEVEL 1: Basic conditions with mathematical constraints
        if (incrementBy == 1 && sampleInputGlobal1 == 0) {
            // Starting condition
            sampleInputGlobal1 = 1;
            fibonacciSequence.push(1);
        }
        // LEVEL 2: Prime number detection (harder)
        else if (isPrime(incrementBy) && isPrime(sampleInputGlobal1)) {
            primeAccumulator += incrementBy;
            sampleInputGlobal1 += primeAccumulator;
            reachedCheckpoints[1] = true;
        }
        // LEVEL 3: Fibonacci sequence detection (very hard)
        else if (isFibonacci(incrementBy) && fibonacciSequence.length > 0) {
            uint256 lastFib = fibonacciSequence.length > 0
                ? fibonacciSequence[fibonacciSequence.length - 1]
                : 0;

            if (incrementBy == nextFibonacci(lastFib)) {
                fibonacciSequence.push(incrementBy);
                sampleInputGlobal1 = sampleInputGlobal1 * 2 + incrementBy;
                reachedCheckpoints[2] = true;
            } else {
                sampleInputGlobal1 += incrementBy / 3;
            }
        }
        // LEVEL 4: Hash-based path (cryptographic difficulty)
        else if (accumulatedHash % 1337 == 0) {
            // Very rare condition
            sampleInputGlobal1 = (sampleInputGlobal1 * 3) + incrementBy;
            reachedCheckpoints[3] = true;
        }
        // LEVEL 5: Complex mathematical relationship
        else if (seed1 > 0 && seed2 > 0 && gcd(seed1, seed2) == incrementBy) {
            // GCD condition
            sampleInputGlobal1 += (seed1 / incrementBy) * (seed2 / incrementBy);
            reachedCheckpoints[4] = true;
        }
        // LEVEL 6: Modular arithmetic puzzle
        else if (
            (incrementBy * incrementBy) % 97 == (sampleInputGlobal1 % 97)
        ) {
            sampleInputGlobal1 = sampleInputGlobal1 + (incrementBy * 97);
            reachedCheckpoints[5] = true;
        }
        // LEVEL 7: Sequence pattern matching
        else if (sequenceCounter > 10 && sequenceCounter % incrementBy == 0) {
            if (blockDelta > 0 && blockDelta < 10) {
                // Timing-sensitive path
                sampleInputGlobal1 += incrementBy * blockDelta;
                reachedCheckpoints[6] = true;
            } else {
                sampleInputGlobal1 += incrementBy;
            }
        }
        // LEVEL 8: Perfect square detection
        else if (isPerfectSquare(sampleInputGlobal1 + incrementBy)) {
            uint256 root = sqrt(sampleInputGlobal1 + incrementBy);
            sampleInputGlobal1 = root * root;
            reachedCheckpoints[7] = true;
        }
        // LEVEL 9: Bit manipulation puzzle
        else if ((incrementBy & (incrementBy - 1)) == 0 && incrementBy > 0) {
            // Power of 2 detection
            uint256 bitPos = log2(incrementBy);
            if (bitPos < 256 && (sampleInputGlobal1 & (1 << bitPos)) == 0) {
                sampleInputGlobal1 |= (1 << bitPos);
                reachedCheckpoints[8] = true;
            } else {
                sampleInputGlobal1 += incrementBy;
            }
        }
        // DEFAULT: Standard increment with overflow protection
        else {
            uint256 oldValue = sampleInputGlobal1;
            sampleInputGlobal1 += incrementBy;

            // Overflow protection with special behavior
            if (sampleInputGlobal1 < oldValue) {
                sampleInputGlobal1 = (oldValue % 1000) + (incrementBy % 1000);
            }
        }

        // BONUS: Unlock special state if multiple checkpoints reached
        uint256 checkpointCount = 0;
        for (uint i = 1; i <= 8; i++) {
            if (reachedCheckpoints[i]) checkpointCount++;
        }

        if (checkpointCount >= 5) {
            // Super rare achievement
            sampleInputGlobal1 = 0xDEADBEEF;
            reachedCheckpoints[9] = true;
        }
    }

    // Helper functions for complex conditions
    function isPrime(uint256 n) internal pure returns (bool) {
        if (n <= 1) return false;
        if (n <= 3) return true;
        if (n % 2 == 0 || n % 3 == 0) return false;

        for (uint256 i = 5; i * i <= n; i += 6) {
            if (n % i == 0 || n % (i + 2) == 0) return false;
        }
        return true;
    }

    function isFibonacci(uint256 n) internal pure returns (bool) {
        if (n == 0 || n == 1) return true;
        uint256 a = 0;
        uint256 b = 1;

        while (b < n) {
            uint256 temp = b;
            b = a + b;
            a = temp;
        }
        return b == n;
    }

    function nextFibonacci(uint256 current) internal pure returns (uint256) {
        if (current == 0) return 1;
        if (current == 1) return 1;

        uint256 a = 0;
        uint256 b = 1;

        while (b <= current) {
            uint256 temp = b;
            b = a + b;
            a = temp;
        }
        return b;
    }

    function gcd(uint256 a, uint256 b) internal pure returns (uint256) {
        while (b != 0) {
            uint256 temp = b;
            b = a % b;
            a = temp;
        }
        return a;
    }

    function isPerfectSquare(uint256 n) internal pure returns (bool) {
        if (n == 0) return true;
        uint256 root = sqrt(n);
        return root * root == n;
    }

    function sqrt(uint256 x) internal pure returns (uint256) {
        if (x == 0) return 0;
        uint256 z = (x + 1) / 2;
        uint256 y = x;

        while (z < y) {
            y = z;
            z = (x / z + z) / 2;
        }
        return y;
    }

    function log2(uint256 x) internal pure returns (uint256) {
        uint256 result = 0;
        while (x > 1) {
            x >>= 1;
            result++;
        }
        return result;
    }

    function sampleInputGlobal1Coverage() public returns (uint256) {
        uint256 value = sampleInputGlobal1;
        uint256 result;

        // CHECKPOINT VERIFICATION - Very hard to reach all
        uint256 checkpointsBitmap;
        for (uint i = 1; i <= 9; i++) {
            if (reachedCheckpoints[i]) {
                checkpointsBitmap |= (1 << i);
            }
        }

        // ULTRA RARE: All checkpoints reached
        if (checkpointsBitmap == 0x3FE) {
            // Binary 1111111110
            emit SampleInputGlobal1Coverage(0xCAFEBABE);
            return 0xCAFEBABE;
        }

        // SPECIAL VALUE: Magic number detection
        if (value == 0xDEADBEEF) {
            emit SampleInputGlobal1Coverage(0xDEADBEEF);
            return 0xDEADBEEF;
        }

        // FIBONACCI SEQUENCE: Check if in sequence
        if (fibonacciSequence.length >= 7) {
            // Very hard: Need 7+ fibonacci numbers in sequence
            uint256 fibSum;
            for (uint i = 0; i < fibonacciSequence.length; i++) {
                fibSum += fibonacciSequence[i];
            }
            if (fibSum == value) {
                emit SampleInputGlobal1Coverage(fibSum * 1000);
                return fibSum * 1000;
            }
        }

        // PRIME ACCUMULATOR: Complex prime-based paths
        if (primeAccumulator > 0) {
            if (isPrime(value) && isPrime(primeAccumulator)) {
                // Both current value and accumulator are prime
                result = value * primeAccumulator;
                if (result < type(uint256).max / 2) {
                    emit SampleInputGlobal1Coverage(result);
                    return result;
                }
            } else if (
                primeAccumulator > 100 && value % primeAccumulator == 0
            ) {
                // Value divisible by large prime accumulator
                emit SampleInputGlobal1Coverage(value / primeAccumulator);
                return value / primeAccumulator;
            }
        }

        // HASH-BASED PATHS: Cryptographic difficulty
        if (accumulatedHash != 0) {
            uint256 hashMod = accumulatedHash % 10000;

            if (hashMod < 10) {
                // Ultra rare: 0.1% chance
                emit SampleInputGlobal1Coverage(type(uint256).max);
                return type(uint256).max;
            } else if (hashMod < 100) {
                // Very rare: 1% chance
                emit SampleInputGlobal1Coverage(value ^ accumulatedHash);
                return value ^ accumulatedHash;
            } else if (hashMod == 1337 || hashMod == 7331) {
                // Easter egg values
                emit SampleInputGlobal1Coverage(hashMod);
                return hashMod;
            }
        }

        // MATHEMATICAL PATTERNS: Complex number theory
        if (value > 0) {
            // Perfect power detection (2^k, 3^k, etc.)
            uint256 base = 2;
            while (base <= 10) {
                uint256 power = base;
                uint256 exponent = 1;
                while (power < value && power > 0) {
                    power *= base;
                    exponent++;
                }
                if (power == value) {
                    // Found perfect power
                    emit SampleInputGlobal1Coverage(base * 1000 + exponent);
                    return base * 1000 + exponent;
                }
                base++;
            }

            // Triangular number detection
            uint256 n = sqrt(2 * value);
            if ((n * (n + 1)) / 2 == value) {
                emit SampleInputGlobal1Coverage(n * n * n);
                return n * n * n;
            }

            // Palindrome detection in base 10
            if (isPalindrome(value)) {
                emit SampleInputGlobal1Coverage(value * 11);
                return value * 11;
            }
        }

        // SEQUENCE COUNTER BASED: Temporal patterns
        if (sequenceCounter > 0) {
            if (sequenceCounter == value) {
                // Counter matches value exactly
                emit SampleInputGlobal1Coverage(
                    sequenceCounter * sequenceCounter
                );
                return sequenceCounter * sequenceCounter;
            } else if (sequenceCounter > 100 && value == sequenceCounter % 97) {
                // Complex modular relationship
                emit SampleInputGlobal1Coverage(sequenceCounter + value);
                return sequenceCounter + value;
            }
        }

        // BIT MANIPULATION: Binary pattern detection
        uint256 bitCount = countBits(value);
        if (bitCount == 1) {
            // Power of 2
            emit SampleInputGlobal1Coverage(log2(value) * 1000);
            return log2(value) * 1000;
        } else if (bitCount == log2(value) + 1) {
            // All bits set (2^n - 1)
            emit SampleInputGlobal1Coverage(value + 1);
            return value + 1;
        } else if ((value & 0xAAAAAAAA) == value) {
            // Alternating bit pattern
            emit SampleInputGlobal1Coverage(0xAAAAAAAA);
            return 0xAAAAAAAA;
        }

        // DEFAULT: Complex calculation based on multiple factors
        result =
            (value * 7 + sequenceCounter * 13 + primeAccumulator * 17) %
            1000000;
        emit SampleInputGlobal1Coverage(result);
        return result;
    }

    function isPalindrome(uint256 n) internal pure returns (bool) {
        uint256 reversed = 0;
        uint256 original = n;

        while (n > 0) {
            reversed = reversed * 10 + (n % 10);
            n /= 10;
        }

        return original == reversed;
    }

    function countBits(uint256 n) internal pure returns (uint256) {
        uint256 count = 0;
        while (n > 0) {
            count += n & 1;
            n >>= 1;
        }
        return count;
    }
}
