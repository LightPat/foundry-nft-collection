// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {MoodNft} from "../src/MoodNft.sol";
import {Test, console} from "forge-std/Test.sol";
import {DeployMoodNft} from "../script/DeployMoodNft.s.sol";
import {Vm} from "forge-std/Vm.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract MoodNftTest is Test {
    string constant NFT_NAME = "Mood NFT";
    string constant NFT_SYMBOL = "MN";

    MoodNft moodNft;
    DeployMoodNft public deployer;

    address USER = makeAddr("user");

    function setUp() public {
        deployer = new DeployMoodNft();
        string memory sadSvg = vm.readFile("./img/sad.svg");
        string memory happySvg = vm.readFile("./img/happy.svg");
        moodNft = new MoodNft(sadSvg, happySvg);
    }
    
     function testInitializedCorrectly() public view {
        assert(keccak256(abi.encodePacked(moodNft.name())) == keccak256(abi.encodePacked((NFT_NAME))));
        assert(keccak256(abi.encodePacked(moodNft.symbol())) == keccak256(abi.encodePacked((NFT_SYMBOL))));
    }

    function testCanMintAndHaveABalance() public {
        vm.prank(USER);
        moodNft.mintNft();

        assert(moodNft.balanceOf(USER) == 1);
    }

    function testTokenURIDefaultIsCorrectlySet() public {
        vm.prank(USER);
        moodNft.mintNft();

        string memory happySvg = vm.readFile("./img/happy.svg");

        assertEq(keccak256(abi.encodePacked(moodNft.tokenURI(0))), keccak256(abi.encodePacked(moodNft.processImageURIToJson(happySvg))));
    }

    function testFlipTokenToSad() public {
        vm.prank(USER);
        moodNft.mintNft();

        vm.prank(USER);
        moodNft.flipMood(0);

        string memory sadSvg = vm.readFile("./img/sad.svg");

        assert(keccak256(abi.encodePacked(moodNft.tokenURI(0))) == keccak256(abi.encodePacked(moodNft.processImageURIToJson(sadSvg))));
    }

    function testFlipTokenToHappy() public {
        vm.prank(USER);
        moodNft.mintNft();

        vm.prank(USER);
        moodNft.flipMood(0);

        vm.prank(USER);
        moodNft.flipMood(0);

        string memory happySvg = vm.readFile("./img/happy.svg");

        assert(keccak256(abi.encodePacked(moodNft.tokenURI(0))) == keccak256(abi.encodePacked(moodNft.processImageURIToJson(happySvg))));
    }
}