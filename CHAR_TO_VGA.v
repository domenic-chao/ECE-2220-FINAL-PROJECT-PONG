// CHAR_TO_VGA
// 	MODULE CONVERTS CHAR TO VGA. CHECKS PIXEL TO SEE IF IT SHOULD BE COLORED OR NOT
// VERSION: 1.0.0
// LAST UPDATED: MAR 17, 2026
// AUTHOR: DOMENIC CHAO

module CHAR_TO_VGA #(
	parameter HEIGHT = 9,		// MUST BE A MULTIPLE OF 9
	parameter WIDTH = 5			// MUST BE A MULTIPLE OF 5
)(
	input [11:0] ascii,			// VALUE OF THE ASCII CHARACTER, NOTE THAT 0 IS BLANK
	input [11:0] xPos,			// SHOULD BE OFFSET TO BE PIXEL INSIDE THE CHARACTER
	input [11:0] yPos,			// SHOULD BE OFFSET TO BE PIXEL INSIDE THE CHARACTER
	
	output reg isColor			// IF THE PIXEL SHOULD BE COLOURED OR NOT
);
	
	reg [3:0] row = 0;
	reg [3:0] col = 0;
	
	always @(*) begin
		
		
		col <= (xPos / (WIDTH / 5)) + 1;
		row <= (yPos / (HEIGHT / 9)) + 1;
		
		// DETERMINE IF FOR THE CHARACTER AT THIS PIXEL IF THIS CHARACTER SHOULD HAVE COLOR AT THIS PIXEL
		case (ascii) 
			12'd00: begin
				isColor <= 0;
			end
			12'd48: begin // CHARACTER: 0 
				case (row)	
					4'd1: begin	
						isColor <= 1;
					end	
					4'd2: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd3: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd4: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd4: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd3: isColor <= 1;
							4'd4: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd5: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd3: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end 	
					4'd6: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd2: isColor <= 1;
							4'd3: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd7: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd2: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd8: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd9: begin	
						isColor <= 1;
					end	
				endcase
			end
			12'd49: begin // CHARACTER: 1 
					case (row)	
						4'd1: begin	
							case (col)	
								4'd3: isColor <= 1;
								default: isColor <= 0;
							endcase
						end
						4'd2: begin	
							case (col)	
								4'd2: isColor <= 1;
								4'd3: isColor <= 1;
								default: isColor <= 0;
							endcase	
						end
						4'd3: begin	
							case (col)	
								4'd1: isColor <= 1;
								4'd3: isColor <= 1;
								default: isColor <= 0;
							endcase	
						end
						4'd4: begin	
							case (col)	
								4'd3: isColor <= 1;
								default: isColor <= 0;
							endcase	
						end
						4'd5: begin	
							case (col)	
								4'd3: isColor <= 1;
								default: isColor <= 0;
							endcase	
						end
						4'd6: begin	
							case (col)	
								4'd3: isColor <= 1;
								default: isColor <= 0;
							endcase	
						end
						4'd7: begin	
							case (col)	
								4'd3: isColor <= 1;
								default: isColor <= 0;
							endcase	
						end
						4'd8: begin	
							case (col)	
								4'd3: isColor <= 1;
								default: isColor <= 0;
							endcase	
						end
						4'd9: begin	
							isColor <= 1;
						end
					endcase
			end
			12'd50: begin // CHARACTER: 2 
			case (row)	
				4'd1: begin	
					isColor <= 1;
				end	
				4'd2: begin	
					case (col)
						4'd5: isColor <= 1;
						default: isColor <= 0;
					endcase	
				end	
				4'd3: begin	
					case (col)
						4'd5: isColor <= 1;
						default: isColor <= 0;
					endcase	
				end	
				4'd4: begin	
					case (col)	
						4'd5: isColor <= 1;
						default: isColor <= 0;
					endcase	
				end	
				4'd5: begin	
					isColor <= 1;
				end 	
				4'd6: begin	
					case (col)	
						4'd1: isColor <= 1;
						default: isColor <= 0;
					endcase	
				end	
				4'd7: begin	
					case (col)	
						4'd1: isColor <= 1;
						default: isColor <= 0;
					endcase	
				end	
				4'd8: begin	
					case (col)	
						4'd1: isColor <= 1;
						default: isColor <= 0;
					endcase	
				end	
				4'd9: begin	
					isColor <= 1;
				end
				endcase
			end
			12'd51: begin // CHARACTER: 3 
				case (row)	
					4'd1: begin	
						isColor <= 1;
					end	
					4'd2: begin	
					case (col)	
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd3: begin	
						case (col)
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd4: begin	
						case (col)	
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd5: begin	
						isColor <= 1;
					end 	
					4'd6: begin	
						case (col)
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd7: begin	
						case (col)	
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd8: begin	
						case (col)
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd9: begin	
						isColor <= 1;
					end	
				endcase	

			end
			12'd52: begin // CHARACTER: 4 
				case (row)	
					4'd1: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd2: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd3: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd4: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd5: begin	
						isColor <= 1;
					end 	
					4'd6: begin	
						case (col)
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd7: begin	
						case (col)
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd8: begin	
						case (col)
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd9: begin	
						case (col)
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
				endcase	
			end
			12'd53: begin // CHARACTER: 5 
				case (row)	
					4'd1: begin	
						isColor <= 1;
					end	
					4'd2: begin	
						case (col)	
							4'd1: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd3: begin	
						case (col)	
							4'd1: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd4: begin	
						case (col)	
							4'd1: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd5: begin	
						isColor <= 1;
					end 	
					4'd6: begin	
						case (col)
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd7: begin	
						case (col)
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd8: begin	
						case (col)
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd9: begin	
						isColor <= 1;
					end	
				endcase
			end
			12'd54: begin // CHARACTER: 6 
				case (row)	
					4'd1: begin	
						isColor <= 1;
					end	
					4'd2: begin	
						case (col)	
							4'd1: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd3: begin	
						case (col)	
							4'd1: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd4: begin	
						case (col)	
							4'd1: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd5: begin	
						isColor <= 1;
					end 	
					4'd6: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd7: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd8: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd9: begin	
						isColor <= 1;
					end	
				endcase	
			end
			12'd55: begin // CHARACTER: 7 
				case (row)	
					4'd1: begin	
						isColor <= 1;
					end	
					4'd2: begin	
						case (col)
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd3: begin	
						case (col)
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd4: begin	
						case (col)
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd5: begin	
						case (col)
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end 	
					4'd6: begin	
						case (col)
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd7: begin	
						case (col)
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd8: begin	
						case (col)
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd9: begin	
						case (col)
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
				endcase
			end
			12'd56: begin // CHARACTER: 8 
				case (row)	
					4'd1: begin	
						isColor <= 1;
					end	
					4'd2: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd3: begin	
					case (col)	
						4'd1: isColor <= 1;
						4'd5: isColor <= 1;
						default: isColor <= 0;
					endcase	
					end	
					4'd4: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd5: begin	
						isColor <= 1;
					end 	
					4'd6: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd7: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd8: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd9: begin	
						isColor <= 1;
					end	
				endcase
			end
			12'd57: begin // CHARACTER: 9 
				case (row)	
					4'd1: begin	
						isColor <= 1;
					end	
					4'd2: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd3: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd4: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd5: begin	
						isColor <= 1;
					end 	
					4'd6: begin	
						case (col)
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd7: begin	
						case (col)
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd8: begin	
						case (col)
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd9: begin	
						case (col)
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					endcase
			end
			12'd58: begin // CHARACTER: : 
				case (row)	
					4'd1: begin	
						isColor <= 0;
					end	
					4'd2: begin	
						case (col)
							4'd2: isColor <= 1;
							4'd3: isColor <= 1;
							default: isColor <= 0;						
						endcase	
					end	
					4'd3: begin	
						case (col)	
							4'd2: isColor <= 1;
							4'd3: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd4: begin	
						isColor <= 0;
					end	
					4'd5: begin	
						isColor <= 0;	
					end 	
					4'd6: begin	
						isColor <= 0;
					end	
					4'd7: begin	
						case (col)	
							4'd1: isColor <= 0;
							4'd2: isColor <= 1;
							4'd3: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd8: begin	
						case (col)
							4'd2: isColor <= 1;
							4'd3: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd9: begin	
						isColor <= 0;
					end	
				endcase	
			end
			12'd65: begin // CHARACTER: A 
				case (row)	
						4'd1: begin	
							case (col)	
								4'd2: isColor <= 1;
								4'd3: isColor <= 1;
								4'd4: isColor <= 1;
								default: isColor <= 0;
							endcase		
						end	
						4'd2: begin	
							case (col)	
								4'd1: isColor <= 1;
								4'd5: isColor <= 1;
								default: isColor <= 0;
							endcase	
						end	
						4'd3: begin	
							case (col)	
								4'd1: isColor <= 1;
								4'd5: isColor <= 1;
								default: isColor <= 0;
							endcase	
						end	
						4'd4: begin	
							case (col)	
								4'd1: isColor <= 1;
								4'd5: isColor <= 1;
								default: isColor <= 0;
							endcase	
						end	
						4'd5: begin	
							case (col)	
								4'd1: isColor <= 1;
								4'd5: isColor <= 1;
								default: isColor <= 0;
							endcase	
						end 	
						4'd6: begin	
							isColor <= 1;
						end	
						4'd7: begin	
							case (col)	
								4'd1: isColor <= 1;
								4'd5: isColor <= 1;
								default: isColor <= 0;
							endcase	
						end	
						4'd8: begin	
							case (col)	
								4'd1: isColor <= 1;
								4'd5: isColor <= 1;
								default: isColor <= 0;
							endcase	
						end	
						4'd9: begin	
							case (col)	
								4'd1: isColor <= 1;
								4'd5: isColor <= 1;
								default: isColor <= 0;
							endcase	
						end	
					endcase
			end
			12'd66: begin // CHARACTER: B 
				case (row)	
						4'd1: begin	
							case (col)	
								4'd1: isColor <= 1;
								4'd2: isColor <= 1;
								4'd3: isColor <= 1;
								4'd4: isColor <= 1;
								default: isColor <= 0;
							endcase	
						end	
						4'd2: begin	
							case (col)	
								4'd1: isColor <= 1;
								4'd5: isColor <= 1;
								default: isColor <= 0;
							endcase	
						end	
						4'd3: begin	
							case (col)	
								4'd1: isColor <= 1;
								4'd5: isColor <= 1;
								default: isColor <= 0;
							endcase	
						end	
						4'd4: begin	
							case (col)	
								4'd1: isColor <= 1;
								4'd5: isColor <= 1;
								default: isColor <= 0;
							endcase	
						end	
						4'd5: begin	
							case (col)	
								4'd1: isColor <= 1;
								4'd2: isColor <= 1;
								4'd3: isColor <= 1;
								4'd4: isColor <= 1;
								default: isColor <= 0;
							endcase	
						end 	
						4'd6: begin	
							case (col)	
								4'd1: isColor <= 1;						
								4'd5: isColor <= 1;
								default: isColor <= 0;
							endcase	
						end	
						4'd7: begin	
							case (col)	
								4'd1: isColor <= 1;							
								4'd5: isColor <= 1;
								default: isColor <= 0;
							endcase	
						end	
						4'd8: begin	
							case (col)	
								4'd1: isColor <= 1;
								4'd5: isColor <= 1;
								default: isColor <= 0;
							endcase	
						end	
						4'd9: begin	
							case (col)	
								4'd1: isColor <= 1;
								4'd2: isColor <= 1;
								4'd3: isColor <= 1;
								4'd4: isColor <= 1;
								default: isColor <= 0;
							endcase	
						end	
					endcase
			end
			12'd67: begin // CHARACTER: C 
				case (row)	
					4'd1: begin	
						case (col)	
							4'd2: isColor <= 1;
							4'd3: isColor <= 1;
							4'd4: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd2: begin	
						case (col)	
							4'd1: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd3: begin	
						case (col)	
							4'd1: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd4: begin	
						case (col)	
							4'd1: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd5: begin	
						case (col)	
							4'd1: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end 	
					4'd6: begin	
						case (col)	
							4'd1: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd7: begin	
						case (col)	
							4'd1: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd8: begin	
						case (col)	
							4'd1: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd9: begin	
						case (col)
							4'd2: isColor <= 1;
							4'd3: isColor <= 1;
							4'd4: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
				endcase
			end
			12'd68: begin // CHARACTER: D 
				case (row)	
					4'd1: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd2: isColor <= 1;
							4'd3: isColor <= 1;
							4'd4: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd2: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd3: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd4: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd5: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end 	
					4'd6: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd7: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd8: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd9: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd2: isColor <= 1;
							4'd3: isColor <= 1;
							4'd4: isColor <= 1;
							default: isColor <= 0;
					endcase	
					end	
				endcase
			end
			12'd69: begin // CHARACTER: E
				case (row)	
					4'd1: begin	
							isColor <= 1;
					end	
					4'd2: begin	
						case (col)	
							4'd1: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd3: begin	
						case (col)	
							4'd1: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd4: begin	
						case (col)	
							4'd1: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd5: begin	
						isColor <= 1;
					end 	
					4'd6: begin	
						case (col)	
							4'd1: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd7: begin	
						case (col)	
							4'd1: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd8: begin	
						case (col)	
							4'd1: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd9: begin	
						isColor <= 1;
					end	
				endcase
			end
			12'd70: begin // CHARACTER: F 
				case (row)	
					4'd1: begin	
						isColor <= 1;
					end	
					4'd2: begin	
						case (col)	
							4'd1: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd3: begin	
						case (col)	
							4'd1: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd4: begin	
						case (col)	
							4'd1: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd5: begin	
						isColor <= 1;
					end 	
					4'd6: begin	
						case (col)	
							4'd1: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd7: begin	
						case (col)	
							4'd1: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd8: begin	
						case (col)	
							4'd1: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd9: begin	
						case (col)	
							4'd1: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
				endcase	
			end
			12'd71: begin // CHARACTER: G 
				case (row)	
					4'd1: begin	
						case (col)	
							4'd2: isColor <= 1;
							4'd3: isColor <= 1;
							4'd4: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd2: begin	
						case (col)	
							4'd1: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd3: begin	
						case (col)	
							4'd1: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd4: begin	
						case (col)	
							4'd1: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd5: begin	
						case (col)	
							4'd1: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end 	
					4'd6: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd4: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd7: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd8: begin	
					case (col)	
						4'd1: isColor <= 1;
						4'd5: isColor <= 1;
						default: isColor <= 0;
					endcase	
					end	
					4'd9: begin	
						case (col)	
							4'd2: isColor <= 1;
							4'd3: isColor <= 1;
							4'd4: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
				endcase	
			end
			12'd72: begin // CHARACTER: H 
				case (row)	
					4'd1: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd2: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd3: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd4: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd5: begin	
						isColor <= 1;	
					end 	
					4'd6: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd7: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd8: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd9: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
				endcase
			end
			12'd73: begin // CHARACTER: I 
				case (row)	
					4'd1: begin	
						isColor <= 1;
					end	
					4'd2: begin	
						case (col)	
							4'd3: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd3: begin	
						case (col)	
							4'd3: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd4: begin	
						case (col)
							4'd3: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd5: begin	
						case (col)	
							4'd3: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end 	
					4'd6: begin	
						case (col)
							4'd3: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd7: begin	
						case (col)	
							4'd3: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd8: begin	
						case (col)	
							4'd3: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd9: begin	
						isColor <= 1;
					end	
				endcase
			end
			12'd74: begin // CHARACTER: J
				case (row)	
					4'd1: begin	
						isColor <= 1;
					end	
					4'd2: begin	
						case (col)	
							4'd4: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd3: begin	
						case (col)	
							4'd4: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd4: begin	
						case (col)	
							4'd4: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd5: begin	
						case (col)	
							4'd4: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end 	
					4'd6: begin	
						case (col)	
							4'd4: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd7: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd4: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd8: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd4: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd9: begin	
						case (col)	
							4'd2: isColor <= 1;
							4'd3: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
				endcase
			end
			12'd75: begin // CHARACTER: K 
				case (row)	
					4'd1: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd2: begin	
					case (col)	
						4'd1: isColor <= 1;
						4'd4: isColor <= 1;
						4'd5: isColor <= 1;
						default: isColor <= 0;
					endcase	
					end	
					4'd3: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd3: isColor <= 1;
							4'd4: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd4: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd2: isColor <= 1;
							4'd3: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd5: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd2: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end 	
					4'd6: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd2: isColor <= 1;
							4'd3: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd7: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd3: isColor <= 1;
							4'd4: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd8: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd4: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd9: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
				endcase	
			end
			12'd76: begin // CHARACTER: L 
				case (row)	
					4'd1: begin	
						case (col)	
							4'd1: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd2: begin	
						case (col)	
							4'd1: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd3: begin	
						case (col)	
							4'd1: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd4: begin	
						case (col)	
							4'd1: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd5: begin	
						case (col)	
							4'd1: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end 	
					4'd6: begin	
						case (col)	
							4'd1: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd7: begin	
						case (col)	
							4'd1: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd8: begin	
						case (col)	
							4'd1: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd9: begin	
						isColor <= 1;
					end	
				endcase
			end
			12'd77: begin // CHARACTER: M 
				case (row)	
					4'd1: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd2: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd2: isColor <= 1;
							4'd4: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd3: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd2: isColor <= 1;
							4'd4: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd4: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd3: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd5: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd3: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end 	
					4'd6: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd7: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd8: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd9: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
				endcase		
			end
			12'd78: begin // CHARACTER: N 
				case (row)	
					4'd1: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd2: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd2: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd3: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd2: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd4: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd3: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd5: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd3: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end 	
					4'd6: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd4: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd7: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd4: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd8: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd9: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
				endcase
			end
			12'd79: begin // CHARACTER: O 
				case (row)	
					4'd1: begin	
						isColor <= 1;
					end	
					4'd2: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd3: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd4: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd5: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end 	
					4'd6: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd7: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd8: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd9: begin	
						isColor <= 1;
					end	
				endcase	
			end
			12'd80: begin // CHARACTER: P 
				case (row)	
						4'd1: begin	
							isColor <= 1;
						end	
						4'd2: begin	
							case (col)	
								4'd1: isColor <= 1;
								4'd5: isColor <= 1;
								default: isColor <= 0;
							endcase	
						end	
						4'd3: begin	
							case (col)	
								4'd1: isColor <= 1;
								4'd5: isColor <= 1;
								default: isColor <= 0;
							endcase	
						end	
						4'd4: begin	
							case (col)	
								4'd1: isColor <= 1;
								4'd5: isColor <= 1;
								default: isColor <= 0;
							endcase	
						end	
						4'd5: begin	
							isColor <= 1;
						end 	
						4'd6: begin	
							case (col)	
								4'd1: isColor <= 1;
								default: isColor <= 0;
							endcase	
						end	
						4'd7: begin	
							case (col)	
								4'd1: isColor <= 1;
								default: isColor <= 0;
							endcase	
						end	
						4'd8: begin	
							case (col)	
								4'd1: isColor <= 1;
								default: isColor <= 0;
							endcase	
						end	
						4'd9: begin	
							case (col)	
								4'd1: isColor <= 1;
								default: isColor <= 0;
							endcase	
						end	
				endcase		
			end
			12'd81: begin // CHARACTER: Q 
				case (row)	
					4'd1: begin	
						isColor <= 1;
					end	
					4'd2: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd3: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd4: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd5: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end 	
					4'd6: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd3: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd7: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd3: isColor <= 1;
							4'd4: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd8: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd4: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd9: begin	
						isColor <= 1;
					end	
				endcase
			end
			12'd82: begin // CHARACTER: R 
				case (row)	
					4'd1: begin	
						isColor <= 1;
					end	
					4'd2: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd3: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd4: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd5: begin	
						isColor <= 1;
					end 	
					4'd6: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd4: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd7: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd4: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd8: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd9: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
				endcase	
			end
			12'd83: begin // CHARACTER: S
				case (row)	
					4'd1: begin	
						isColor <= 1;
					end	
					4'd2: begin	
						case (col)	
							4'd1: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd3: begin	
						case (col)	
							4'd1: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd4: begin	
						case (col)	
							4'd1: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd5: begin	
						isColor <= 1;
					end 	
					4'd6: begin	
						case (col)
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd7: begin	
						case (col)
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd8: begin	
						case (col)
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd9: begin	
						isColor <= 1;
					end	
				endcase	
			end
			12'd84: begin // CHARACTER: T 
				case (row)	
					4'd1: begin	
						isColor <= 1;
					end	
					4'd2: begin	
						case (col)
							4'd3: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd3: begin	
						case (col)
							4'd3: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd4: begin	
						case (col)
							4'd3: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd5: begin	
						case (col)
							4'd3: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end 	
					4'd6: begin	
						case (col)	
							4'd3: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd7: begin	
						case (col)	
							4'd3: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd8: begin	
						case (col)	
							4'd3: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd9: begin	
						case (col)	
							4'd3: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
				endcase
			end
			12'd85: begin // CHARACTER: U 
				case (row)	
					4'd1: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd2: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd3: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd4: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd5: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end 	
					4'd6: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd7: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd8: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd9: begin	
						isColor <= 1;
					end	
				endcase
			end
			12'd86: begin // CHARACTER: V 
				case (row)	
					4'd1: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd2: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd3: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd4: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd5: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end 	
					4'd6: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd2: isColor <= 1;
							4'd4: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd7: begin	
						case (col)
							4'd2: isColor <= 1;
							4'd4: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd8: begin	
						case (col)
							4'd2: isColor <= 1;
							4'd3: isColor <= 1;
							4'd4: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd9: begin	
						case (col)
							4'd3: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
				endcase
			end
			12'd87: begin // CHARACTER: W 
				case (row)	
					4'd1: begin	
					case (col)	
						4'd1: isColor <= 1;
						4'd5: isColor <= 1;
						default: isColor <= 0;
					endcase	
					end	
					4'd2: begin	
					case (col)	
						4'd1: isColor <= 1;
						4'd5: isColor <= 1;
						default: isColor <= 0;
					endcase	
					end	
					4'd3: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd4: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd5: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end 	
					4'd6: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd3: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd7: begin	
						isColor <= 1;
					end	
					4'd8: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd2: isColor <= 1;
							4'd4: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd9: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					endcase
			end
			12'd88: begin // CHARACTER: X 
				case (row)	
					4'd1: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd2: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd2: isColor <= 1;
							4'd4: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd3: begin	
						case (col)
							4'd2: isColor <= 1;
							4'd4: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd4: begin	
						case (col)
							4'd2: isColor <= 1;
							4'd3: isColor <= 1;
							4'd4: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd5: begin	
						case (col)
							4'd3: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end 	
					4'd6: begin	
						case (col)
							4'd2: isColor <= 1;
							4'd3: isColor <= 1;
							4'd4: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd7: begin	
						case (col)
							4'd2: isColor <= 1;
							4'd4: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd8: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd2: isColor <= 1;
							4'd4: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd9: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
				endcase
			end
			12'd89: begin // CHARACTER: Y 
				case (row)	
					4'd1: begin	
					case (col)	
						4'd1: isColor <= 1;
						4'd5: isColor <= 1;
						default: isColor <= 0;
					endcase	
					end	
					4'd2: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd3: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd4: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd5: begin	
						case (col)
							4'd2: isColor <= 1;
							4'd4: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end 	
					4'd6: begin	
						case (col)
							4'd2: isColor <= 1;
							4'd3: isColor <= 1;
							4'd4: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd7: begin	
						case (col)
							4'd3: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd8: begin	
						case (col)
							4'd3: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd9: begin	
						case (col)
							4'd3: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
				endcase
			end
			12'd90: begin // CHARACTER: Z 
				case (row)	
					4'd1: begin	
						isColor <= 1;
					end	
					4'd2: begin	
						case (col)
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd3: begin	
						case (col)
							4'd3: isColor <= 0;
							4'd4: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd4: begin	
						case (col)	
							4'd3: isColor <= 1;
							4'd4: isColor <= 1;
							4'd5: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd5: begin	
						case (col)
							4'd2: isColor <= 1;
							4'd3: isColor <= 1;
							4'd4: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end 	
					4'd6: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd2: isColor <= 1;
							4'd3: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd7: begin	
						case (col)	
							4'd1: isColor <= 1;
							4'd2: isColor <= 1;
							default: isColor <= 0;
						endcase	
					end	
					4'd8: begin	
						case (col)	
								4'd1: isColor <= 1;
								default: isColor <= 0;
						endcase	
					end	
					4'd9: begin	
						isColor <= 1;
					end	
				endcase
			end
		endcase
	end
endmodule