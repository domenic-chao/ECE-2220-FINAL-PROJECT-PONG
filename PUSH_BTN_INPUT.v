// PUSH_BTN_INPUT
// 	MODULE TO MOVE THE BLOCKERS AND BALLS IF IN LAUNCH MODE BASED ON INPUTS
// VERSION: 1.0.0
// LAST UPDATED: MAR 16, 2026
// AUTHOR(S): Leon Fust, Israel Igbinawan
module PUSH_BTN_INPUT (
	input upBtn,								// THE PUSH BTN FOR PLAYER ONE UP
	input downBtn,								// THE PUSH BTN FOR PLAYER ONE DOWN
	
	output moveUp,
	output moveDown
);
	
	assign moveUp = !upBtn;
	assign moveDown = !downBtn;

endmodule
