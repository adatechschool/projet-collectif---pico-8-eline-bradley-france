pico-8 cartridge // http://www.pico-8.com
version 38
__lua__

--Main game loop
function _init()
	create_player()
	score = 0
	init_msg()
	create_msg("welcome", "You have to collect all the vegetables for the other mice!")
end

function _update()
	--Stops player moving whilst message is displayed
	if not messages[1] then
		player_movement()
	end
	update_camera()
	pick_up()
	player_animation()
	open_door()
	update_msg()
end

function _draw()
	cls()
	draw_map()
	draw_player()
	print(fill_the_basket(), 4, 4, 7)
	draw_score()
	draw_msg()
end

--PLayer object created to contain properties
function create_player()
	player = {
		x = 6,
		y = 6,
		timingup = 0.20,
		timing = 0.50,
		anim1 = 12,
		anim2 = 29,
		sprite = 12
	}
end

--Function which enables player movement and collision/blocking movement
function player_movement()
	newx = player.x
	newy = player.y

	if (btnp(➡️)) newx += 1
	if (btnp(⬅️)) newx -= 1
	if (btnp(⬇️)) newy += 1
	if (btnp(⬆️)) newy -= 1
	if not check_flag(0, newx, newy) then
		player.x = mid(0, newx, 100)
		player.y = mid(0, newy, 23)
	end
end

--Function for looping through sprites for animation effect
function player_animation()
	if btnp(➡️) or btnp(⬅️) or btnp(⬇️) then
		player.anim1 += player.timing
		if player.anim1 > 15 then
			player.anim1 = 12
		end
	elseif btn(⬆️) then
		player.anim2 += player.timingup
		if player.anim2 > 31 then
			player.anim2 = 29
		end
	end
end

--Limits the camera screen/unlocks after objective met
function update_camera()
	camx = mid(0, player.x - 7.5, 43 - 15)
	camy = mid(0, player.y - 7.5, 24 - 15)
	camera(camx * 8, camy * 8)
	if open_door() == true then
		camx = mid(0, player.x - 7.5, 100 - 15)
		camy = mid(0, player.y - 7.5, 24 - 15)
		camera(camx * 8, camy * 8)
	end
end

--Limits map size until object is met.
function draw_map()
	map(0, 0, 0, 0, 44, 25)
	if open_door() == true then
		map(0, 0, 0, 0, 200, 25)
	end
end

-- Draws the player sprite on the map using animation logic
function draw_player()
	if btn(➡️) or btn(⬅️) or btn(⬇️) then
		frame = player.anim1 % 3.75
		local sprite = 12 + frame
		spr(sprite, player.x * 8, player.y * 8)
	elseif btn(⬆️) then
		frame = player.anim2 % 4
		local sprite = 29 + frame
		spr(sprite, player.x * 8, player.y * 8)
	else
		spr(player.sprite, player.x * 8, player.y * 8)
	end
end

--Replaces fruit and veg sprites and increases score
function pick_up()
	if check_flag(1, newx, newy) then
		mset(newx, newy, 1)
		score += 1
	elseif check_flag(2, newx, newy) then
		mset(newx, newy, 39)
		score += 1
	end
end

--Beautiful function for verification of flag present on map
function check_flag(flag, x, y)
	local sprite = mget(x, y)
	return fget(sprite, flag)
end

--Prints encouraging phrase onscreen(camera)
function fill_the_basket()
	camera()
	if score == 0 then
		return "you must collect vegetables!"
	elseif score <= 10 then
		return "keep gardening!"
	elseif score <= 20 then
		return "you're doing great!"
	elseif score <= 30 then
		return "nearly there!"
	elseif score <= 44 then
		return "just a few more, you can do it!"
	else
		return "congrats,the door is open!!"
	end
end

--Prints score onscreen(camera)
function draw_score()
	camera()
	spr(78, 4, 10)
	print(score, 14, 12, 7)
end

--Opens the door and provides check condition for embiggening the map/camera
function open_door()
	if score > 44 then
		mset(43, 5, 85)
		mset(43, 6, 84)
		return true
	end
end

--creates table with message to display
function init_msg()
	messages = {}
end

-- Prints message on screen
function draw_msg()
	if messages[1] then
		local y = 60
		rectfill(6, y,6+#msg_title*4, y + 6, 2)
		print(msg_title, 7, y+1, 7)
		print(messages[1], 0, y + 10, 7)
	end
end

-- Enables the message to be deleted from table
function update_msg()
	if btnp(❎) then
		deli(messages, 1)
	end
end

function create_msg(name, ...)
	msg_title = name
	messages = { ... }
end

__gfx__
333333333333333333333333333bb333cccccccc333883333333333343b4b3b444444444444bb4b3444443343333333377700777777007777770077777700777
37333333333333333333373333bbbb33ccc77ccc3388883311111111443b3b44444444444444b3bb44499aa3493349337e7777e77e7777e77e7777e77e7777e7
7a73333333333333333378733bbb3bb3cc7777cc38878883cccccccc4e8788e478088887444999344b9994a34933493377377377773773777737737777377377
3733333333333333333337333b3bbbb3c777777c88888788cccccccce788888e78888087449999bbba444ab344444444007e77000077e7000077e700007e7700
333333a3333333333333333333bbbb33cccccccc87888888cccccccce888878e78808887499a994bbaaaab334499449907c77c7007c77c7007c77c7007c77c70
33333a9a333333333333333333344333cccccccc33377333cccccccc4e8888e4b788887b99a994443bbbb33444334433e0c11c0000c11c0000c11c0ee0c11c00
333333a3333333333333333333344333cccccccc33377733cccccccc44e78e443b7777b39999444443333344443344330ecccc0007cccc7007cccce00ecccc70
33333333333333333333333333444433cccccccc37777773bbbbbbbb444ee44443bbbb3499944444443334443333333300700700000000000000070000700000
3333333333333333000cc0004433334400b0b0b033333333333333333338733333333333333bb333cccccccc4444444388888888777007777770077777700777
344444333333333300cccc004343b334000b3b003333a33333333333338787333333ee3333bb8b33cccccccc4444444388888888777777777777777777777777
34a44433333333330cccc7c033333b330043b900333a0a333333333338787873333eeae333bbbbb3cccccccc4444444388888888777777777777777777777777
3444a43338383333cccccc7c3b33333304949494333ba333333338338787878733eaee333bb8bb8bc77ccccc4444444388888888007777000077770000777700
3444443333833333cccccc7c4bbb333409494944333b333333338a8339999993333eeb33bbbbbbb3cccccccc444444438888888807cccc7007cccc7007cccc70
34a4443333333333ccccc7cc4bab33330494949433333333333338b3392992933333b33333344333ccccc777444444438888888800ccec0000cecc0000ccec00
34444a3333333b3b0cccccc0babbb333094949443333333333333333399999933333333333344333cccccccc444444438888888800ccec0000ccec7007cecc00
33333333333333b300cccc00bb443334004444403333333333333333399299933333333333444433bbbbbbbb3333333388888888007007000070000000000700
377733333333333333333bb33333344333333443444444444444444444444444cccccccccccacccccccccccccccccccccba8eccceccccccccccccccc13333333
7999733333399333388ebbe333333a933333bb334ffffff44944444444444444ccccccccccaaaccccccccccc49cc49cc49ba49cc8eeeccccccccccccc1111111
7aa97333333934338888b38e33333aa33333ba334ff44ff44444444444444444cccccccccaaaaacccccccccc49cc49cc49cb49eca888eecccccccccccccccccc
37773333333934338882b88833333aa3333bbba34ff44ff44444444444444444ccccccccaaaaaaaccccccccc4444444444444444baaa88eecccccccccc777ccc
b3b33333a9a9a9a9288828883333aa9333bbbbba4ff44ff44444444444444444cccccccccaaaaacccc77cccc4499449944994499cbbbaa88eecccccccccccccc
3bb3b3339a9a9a9428888888333aa933333bbbbb4ff44ff44444449444444444ccccccccccaaacccc777cccc4433443344334433ccccbbaa88eccccccccccc7c
33bb333339a9a94328888888aaaa9333333bbbbb4ffffff4444a444444444444cccccccccccacccccccccccc4433443344334433ccccccbbaa8eccccccccccc7
33b33333339a9433322228839aa9333333333bb3444444444444444444444444cccccccccccccccccccccccc3333333333333333ccccccccbba8eccccccccccc
13333333cccce8ab33333333ccccccccccccccceeeeeeeeecccccccc33449333334433333344333333333333333333333333333bbbbbbbbbb333333333333333
1111133349ce49bc37333333cccccccccccceee888888888cccccccc33443333334493333344333333333333333333333333333b33333333b333333333333333
ccccc13349e849cc7a733333ccccccccccee888aaaaaaaaacccccccc33443333334433333344933333333333333333333333333b33333333b333333333333333
cccccc134444444437333333ccccccccee88aaabbbbbbbbbcccccccc33449333334433333344333333333333333333333333333b33333333b333333333333333
ccccccb144994499333333a3ccccccce88aabbbccccccccccccccccc33443333334493333344333333333333333333333333333b33333333b333333333333333
cccccb134433443333333a9acccccce8aabbcccccccccccccccccccc33443333334433333344933333333333333333333333333b33333333b333333333333333
bbbbb13344334433333333a3ccccce8abbcccccccccccccccccccccc33449333334433333344333344443333333333443333333b33333333b333333333333333
b33333333333333333333333cccce8abccccccccccccccccbbbbbbbb33443333334493333344333344443333333333443333333b33333333b3333333bbbbbbbb
b33333333333333b3333333333333333c3bcb3bcccc88ccccccccccccccbbcb3ccccc33ccccccbbcccccc44cccccc44ccbbcc9a9334443330000000000000000
33333333333333333333333333333333cc3b3bcccc8888ccccccccccccccb3bbccc99aa3c88ebbecccccca9cccccbbccccbb9a9a494449330009900000000000
33333333333333333333333333333333ce8788ecc887888c78088887ccc9993ccb9994a38888b38ecccccaacccccbacc33b9a9a9494449330009040000000000
33333333333333333333333333333333e788888e8888878878888087cc9999bbba444ab38882b888cccccaaccccbbbaccb9a9a9c444444330009040000000000
33333333333333333333333333333333e888878e8788888878808887c99a99cbbaaaab3328882888ccccaa9cccbbbbbacba9a9bc44994433a9a9a9a900000000
33333333333333333333333333333333ce8888ecccc77cccb788887b99a99ccc3bbbb33c28888888cccaa9cccccbbbbbcbba9bbb443344339a9a9a9400000000
33333333333333333333333333333333cce78eccccc777cc3b7777b39999ccccc33333cc28888888aaaa9ccccccbbbbbb3bbb3cb4433443309a9a94000000000
3333333333333333b33333333333333bccceecccc777777cc3bbbb3c999ccccccc333cccc222288c9aa9cccccccccbbcbbccc3cc33333333009a940000000000
8888888388888883333333333333333388eeeee3333338e355544555666446664444444444444444444444444444444499999999000000000000000000000000
8888888388888883333333331333333388eeeee333338ee35e5555e56f6666f64777477746664666455545554444444499999999000000000000000000000000
8888888388888883333333331333333388eeeee33338eee3551551556656656647e777e746e666e645f555f54444444444444444000000000000000000000000
8888888388888883333333331333331188eeee83338eeee344556544446e66444775757746656566455353554444444444444444000000000000000000000000
888888838888888333333333133331c188eee83338eeeee345855854463663644447e7444446e6444445e5444444444444444444000000000000000000000000
888888838888888333333333111111c188ee833388eeeee3e4888844f4333344447d7d7444686864445252544444444444444444000000000000000000000000
888888838888888333333333ccccccc188e8333388eeeee34e8888444f333364444ddd4444488844444222449999999944444444000000000000000000000000
333333338888898333333333ccccccc13333333388eeee9344544544446444444447474444464644444545449999999944444444000000000000000000000000
eeeeeee2eeeeeeee00000000ccccccc10aaa0000aa00a000aa00aa00aa0000aa0000aaa000aaa00000000aaa000aaa0000000000000000000000000000000000
eeeeeee2eeeeeeee00000000cc11111100aaaaaaaa00a000aa00aa000aaa00aaaaaaa00000aaaaaa00000aaa0000aa0000000000000000000000000000000000
eeeeeee2eeeeeeee00000000cc133333000aaaaaaa00a000aa00aa0000aa00aaaaaa000000aaaaaa00000aaa0000aa0000000000000000000000000000000000
eeeeeee2eeeeeeee00000000cc111113000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
eeeeeee2eeeeeeee00000000cccccc13000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
eeeeeee2eeeeeeee00000000ccc11113000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
eeeeeee2eeeeeeee00000000ccc13333000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
22222222eeeeeee20000000011113333000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
333333333333333333333333eeeeeeeeb33333333333333bbbbbbbbbbbbbbbbb333333333333333bb33333331111111111111111111111114bb449a900000000
333333878787878787333333eeeeeeeeb33333333333333b3333333bb3333333333333333333333333333333cccccccccccccccccccccccc44bb9a9a00000000
333338787878787878733333eeeeeeeeb33333333333333b3333333bb3333333333333333333333333333333cccccccccccccccccccccccc33b9a9a900000000
333387878787878787873333eeeeeeeeb33333333333333b3333333bb333333333333333333333333333333377cccccccccccccccccccccc4b9a9a9400000000
333878787878787878787333eeeeeeeeb33333333333333b3333333bb3333333333333333333333333333333cccccccccccccccccccc777c4ba9a9b400000000
338787878787878787878733eeeeeeeeb33333333333333b3333333bb3333333333333333333333333333333cccccccccccccccccccccccc4bba9bbb00000000
387878787878787878787873eeeeeeeeb33333333333333b3333333bb3333333333333333333333333333333ccccccccccccccccccccccccb3bbb34b00000000
878787878787878787878787eeeeeeeebbbbbbbbbbbbbbbb3333333bb33333333333333b3333333333333333ccccc77cccccccccccccccccbb44434400000000
4448844444444bb44444400444444004444444444444444444444444444444440000000000000000000000000000000000000000000000000000000000000000
44888844488ebbe444444a944444bb44440444444444444444444444441114440000000000000000000000000000000000000000000000000000000000000000
488788848888b48e44444aa44444ba44442444144444444444666444444414440000000000000000000000000000000000000000000000000000000000000000
888887888882b88844444aa4444bbba4422244244444444446666644444111440000000000000000000000000000000000000000000000000000000000000000
87888888288828884444aa9444bbbbba422042224449999446666644441111140000000000000000000000000000000000000000000000000000000000000000
4447744428888888444aa944444bbbbb4220422244949994466ddd4444111c140000000000000000000000000000000000000000000000000000000000000000
4447774428888888aaaa9444444bbbbb4220422249994994466ddd444411c1140000000000000000000000000000000000000000000000000000000000000000
47777774422228849aa9444444444bb4422242229499999446666644441111140000000000000000000000000000000000000000000000000000000000000000
__gff__
0000000000020104040404010000000000000004000000000000010000000000000002020200000000000001010000010101000000000101010100000000000000000000040204040402020204010000010100010000000000000000000000000000000100000000000000000000000001010101000000000000000101010400
0202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
2828282828282828282828282828282828282828282828282828282828282828282828282828282828282828282827272727272727272727272727272727272727272727272727272727272727272727272727272727272727272727272727272727272727282828282828282828282828282828280000000000000000000000
2a2828282828282828282828282a28282828282828282828042828282828282828282828282828282828282828045c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c282828282828282828282828282828280000000000000000000000
28280428282928282a2828282828282828282828282828282828282828282828282828282928282828282828282827272727272727272727272727272727272727272727272727272727272727272727272727272727272727272727272727272727272727282828282828282828282828282828280000000000000000000000
2828282828282828282828283334352d2e28282828280428283334352d2e2828282828282828282828282828282827272727272727272727272727272727272727272727272727272727272727272727272727272727272727272727272727272727272727282828282828282828282828282828280000000000000000000000
2b2b2b2b2b2b2b2b2b2b2b2b312b2b2b2c2b2b2b2b2b2b2b2b312b2b2b2c2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b275a27572756275858275927275927272727272727272727272727272727272727582727272727272727272727272727272727272727272b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b0000000000000000000000
0101010101433f3f3f3f3f3f3f3f3f3f4201011101010101010101010101010101010101020101010101015101015c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c010101010101010101010101010101010000000000000000000000
01010101013c272627262727272627273e2001010101010105010501050101783f3f3f3f3f3f3f3f75263e50010127272727272727272727272727272727272727272727272727272727272727272727272727272727272727272727272727272727272727010101010101010101010101010101010000000000000000000000
3f3f3f3f3f75262613261326132713273e010101010101433f3f3f3f3f42013c272726272727272727273e37010127272727272727272727272727272727272727272727272727272727272727272727272727272727272727272727272727272727272727010101010101010101010101010101010000000000000000000000
262727262727272726272627272726263e0101011101013c26272727273e013c27773d3d3d3d3d7627777a38010127275927272727272759272727272727275927272727272727272756272727272727272727272727272727272727272727272727272727010101010101010101010101010101010000000000000000000000
3d3d3d3d3d76267e277e277e277e27273e0101010101013c2707270727743f75273e22012201223c273e013901015c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c010101010101010101010101010101010000000000000000000000
01013201113c272726272727272726273e2001200120013c2727262727272627273e01010101013c273e0137010127272727272727272727272727272727272727272727272727272727272727272727272727272727272727272727272727272727272727010101010101010101010101010101010000000000000000000000
01010101013c27270a270a260a270a27743f3f3f3f3f3f750827082708773d76273e01010101013c263e5238010127272727272727272727272727272727272727272727272727272727272727272727272727272727272727272727272727272727272727010101010101010101010101010101010000000000000000000000
01010201013c26272727262727272626272727262727272627272727273e523c263e23012301233c273e52390101275a2727272756592727272727272727562727272727272727272727272727272727272727272727272727272727272727272727272727010101010101010101010101010101010000000000000000000000
01320101323c27092709270927092727773d3d3d3d3d3d76277e277e263e523c273e01010101013c273e523701015c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c010101010101010101010101010101010000000000000000000000
01010101013c272726272727262727273e0101521152523c27262727273e523c27743f3f3f3f3f75273e5238010127272727272727272727272727272727272727272727272727272727272727272727272727272727272727272727272727272727272727010101010101010101010101010101010000000000000000000000
0101010101413d3d3d3d3d3d3d3d3d3d400101525252523c27272727273e523c2727272727262727273e5239010127272727272727272727272727272727272727272727272727272727272727272727272727272727272727272727272727272727272727010101010101010101010101010101010000000000000000000000
0101011101010102010101010101010101110152525252413d3d3d3d3d4052793d3d3d3d3d3d3d3d3d7a523701012727272727272727272727275a272727272727272727272727272756272727272727272727275827272727272727272727272727272727010101010101010101010101010101010000000000000000000000
010101010101010101010101010101010101015252525252525252525252525252525252525252525252523801015c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c010101010101010101010101010101010000000000000000000000
0101010101010101010101010101010101010252525252522352235223525270717171725252245252245239010127272727272727272727272727272727272727272727272727272727272727272727272727272727272727272727272727272727272727010101010101010101010101010101010000000000000000000000
0105010122010105011122010101010101010152521152525252525252525273736160735252525252525237010127272727272727272727272727272727272727272727272727272727272727272727272727272727272727272727272727272727272727010101010101010101010101010101010000000000000000000000
7b7b7b7b7b7b7b7b7b7b7b7b257b7b7b7b7b7b2f5352525223522352235252736160737352522452522452380101275a2727272727272727272727272727272727275627272727272727272727272727272727272727272727272727272727272727272727010101010101010101010101010101010000000000000000000000
282828282828282828282828252828282828282863525252525252525252526160737373525252525252523901015c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c010101010101010101010101010101010000000000000000000000
1a36361a3636361a36363636253636361a1a361a305252522352235223525260737373735252245252245237010127272727272727272727272727272727272727272727272727272727272727272727272727272727272727272727272727272727272727010101010101010101010101010101010000000000000000000000
0501050105010501050105010201050101010152525252525252525252525252525252525252525252525238010127272727272727272727272727272727272727272727272727272727272727272727272727272727272727272727272727272727272727010101010101010101010101010101010000000000000000000000
0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b4d0101272727272727272727272727272727272727272727272727275a2727272727272727272756272727272727272727272727272727272727010101010101010101010101010101010000000000000000000000
