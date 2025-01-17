include("Header.jl")

function SeisPatch(in,out,param)

    style = get(param,"style","sxsygxgy")
    if (style == "sxsygxgy")
		key = ["t","isx","isy","igx","igy"]
		min_ix1 = get(param,"min_isx",0)
		max_ix1 = get(param,"max_isx",0)
		min_ix2 = get(param,"min_isy",0)
		max_ix2 = get(param,"max_isy",0)
		min_ix3 = get(param,"min_igx",0)
		max_ix3 = get(param,"max_igx",0)
		min_ix4 = get(param,"min_igy",0)
		max_ix4 = get(param,"max_igy",0)
	elseif (style=="mxmyhxhy")
		key = ["t","imx","imy","ihx","ihy"]
		min_ix1 = get(param,"min_imx",0)
		max_ix1 = get(param,"max_imx",0)
		min_ix2 = get(param,"min_imy",0)
		max_ix2 = get(param,"max_imy",0)
		min_ix3 = get(param,"min_ihx",0)
		max_ix3 = get(param,"max_ihx",0)
		min_ix4 = get(param,"min_ihy",0)
		max_ix4 = get(param,"max_ihy",0)
	elseif (style=="mxmyhaz")
		key = ["t","imx","imy","ih","iaz"]
		min_ix1 = get(param,"min_imx",0)
		max_ix1 = get(param,"max_imx",0)
		min_ix2 = get(param,"min_imy",0)
		max_ix2 = get(param,"max_imy",0)
		min_ix3 = get(param,"min_ih",0)
		max_ix3 = get(param,"max_ih",0)
		min_ix4 = get(param,"min_iaz",0)
		max_ix4 = get(param,"max_iaz",0)
	elseif (style=="sxsyhxhy")
		key = ["t","isx","isy","ihx","ihy"]
		min_ix1 = get(param,"min_isx",0)
		max_ix1 = get(param,"max_isx",0)
		min_ix2 = get(param,"min_isy",0)
		max_ix2 = get(param,"max_isy",0)
		min_ix3 = get(param,"min_ihx",0)
		max_ix3 = get(param,"max_ihx",0)
		min_ix4 = get(param,"min_ihy",0)
		max_ix4 = get(param,"max_ihy",0)
	elseif (style=="gxgyhxhy")
		key = ["t","igx","igy","ihx","ihy"]
		min_ix1 = get(param,"min_igx",0)
		max_ix1 = get(param,"max_igx",0)
		min_ix2 = get(param,"min_igy",0)
		max_ix2 = get(param,"max_igy",0)
		min_ix3 = get(param,"min_ihx",0)
		max_ix3 = get(param,"max_ihx",0)
		min_ix4 = get(param,"min_ihy",0)
		max_ix4 = get(param,"max_ihy",0)
	elseif (style=="sxsyhaz")
		key = ["t","isx","isy","ih","iaz"]
		min_ix1 = get(param,"min_isx",0)
		max_ix1 = get(param,"max_isx",0)
		min_ix2 = get(param,"min_isy",0)
		max_ix2 = get(param,"max_isy",0)
		min_ix3 = get(param,"min_ih",0)
		max_ix3 = get(param,"max_ih",0)
		min_ix4 = get(param,"min_iaz",0)
		max_ix4 = get(param,"max_iaz",0)
	elseif (style=="gxgyhaz")
		key = ["t","igx","igy","ih","iaz"]
		min_ix1 = get(param,"min_igx",0)
		max_ix1 = get(param,"max_igx",0)
		min_ix2 = get(param,"min_igy",0)
		max_ix2 = get(param,"max_igy",0)
		min_ix3 = get(param,"min_ih",0)
		max_ix3 = get(param,"max_ih",0)
		min_ix4 = get(param,"min_iaz",0)
		max_ix4 = get(param,"max_iaz",0)
	else
		error("style not defined.")
	end
	nx1 = max_ix1 - min_ix1 + 1
	nx2 = max_ix2 - min_ix2 + 1
	nx3 = max_ix3 - min_ix3 + 1
	nx4 = max_ix4 - min_ix4 + 1

    stream = open(join([in ".seish"]))
    seek(stream, header_count["n1"])
    nt = read(stream,Int32)
    seek(stream, header_count["d1"])
    dt = read(stream,Float32)
    seek(stream, header_count["o1"])
    ot = read(stream,Float32)
    
    close(stream)
	it_WL = get(param,"it_WL",nt)
	it_WO = get(param,"it_WO",0)
	ix1_WL = get(param,"ix1_WL",nx1)
	ix1_WO = get(param,"ix1_WO",0)
	ix2_WL = get(param,"ix2_WL",nx2)
	ix2_WO = get(param,"ix2_WO",0)
	ix3_WL = get(param,"ix3_WL",nx3)
	ix3_WO = get(param,"ix3_WO",0)
	ix4_WL = get(param,"ix4_WL",nx4)
	ix4_WO = get(param,"ix4_WO",0)

	tmax = ot + dt*nt
	it_NW = int(floor(nt/(it_WL-it_WO)))
	ix1_NW = int(floor(nx1/(ix1_WL-ix1_WO)))
	ix2_NW = int(floor(nx2/(ix2_WL-ix2_WO)))
	ix3_NW = int(floor(nx3/(ix3_WL-ix3_WO)))
	ix4_NW = int(floor(nx4/(ix4_WL-ix4_WO)))


        if (ot + dt*(it_NW-1)*(it_WL-it_WO) + dt*it_WL < tmax)
		it_NW += 1
	end
        if (min_ix1 + (ix1_NW-1)*(ix1_WL-ix1_WO) + ix1_WL < max_ix1)
		ix1_NW += 1
	end
        if (min_ix2 + (ix2_NW-1)*(ix2_WL-ix2_WO) + ix2_WL < max_ix2)
		ix2_NW += 1
	end
        if (min_ix3 + (ix3_NW-1)*(ix3_WL-ix3_WO) + ix3_WL < max_ix3)
		ix3_NW += 1
	end
        if (min_ix4 + (ix4_NW-1)*(ix4_WL-ix4_WO) + ix4_WL < max_ix4)
		ix4_NW += 1
	end

	NW=it_NW*ix1_NW*ix2_NW*ix3_NW*ix4_NW

	#println("it_NW=",it_NW)
	#println("ix1_NW=",ix1_NW)
	#println("ix2_NW=",ix2_NW)
	#println("ix3_NW=",ix3_NW)
	#println("ix4_NW=",ix4_NW)
    
    list = Any[]
	for it_W = 1 : it_NW
		mint = ot + dt*(it_W-1)*(it_WL-it_WO)
        maxt = mint + dt*it_WL
        if (maxt >= tmax)
        	maxt = tmax
        end
        for ix1_W = 1 : ix1_NW
			minx1 = min_ix1 + (ix1_W-1)*(ix1_WL-ix1_WO)
        	maxx1 = minx1 + ix1_WL
        	if (maxx1 >= max_ix1)
        		maxx1 =  max_ix1
        	end
        	for ix2_W = 1 : ix2_NW
				minx2 = min_ix2 + (ix2_W-1)*(ix2_WL-ix2_WO)
        		maxx2 = minx2 + ix2_WL
        		if (maxx2 >= max_ix2)
        			maxx2 = max_ix2
        		end
        		for ix3_W = 1 : ix3_NW
					minx3 = min_ix3 + (ix3_W-1)*(ix3_WL-ix3_WO)
        			maxx3 = minx3 + ix3_WL
        			if (maxx3 >= max_ix3)
        				maxx3 = max_ix3
        			end
        			for ix4_W = 1 : ix4_NW
						minx4 = min_ix4 + (ix4_W-1)*(ix4_WL-ix4_WO)
        				maxx4 = minx4 + ix4_WL
        				if (maxx4 >= max_ix4)
        					maxx4 = max_ix4
        				end
        				patch_name = join([out "_" it_W "_" ix1_W "_" ix2_W "_" ix3_W "_" ix4_W])
        				minval=[mint minx1 minx2 minx3 minx4]
        				maxval=[maxt maxx1 maxx2 maxx3 maxx4]
        				#println("key=",key)
        				#println("minval=",minval)
        				#println("maxval=",maxval)
        				#@printf("          %s      %s      %s      %s      %s\n",key[1],key[2],key[3],key[4],key[5])
        				#@printf("%11.2f   %6d   %6d   %6d   %6d\n",minval[1],minval[2],minval[3],minval[4],minval[5])
        				#@printf("%11.2f   %6d   %6d   %6d   %6d\n",maxval[1],maxval[2],maxval[3],maxval[4],maxval[5])
        				SeisWindow(in,patch_name,key,minval,maxval)
        				list = push!(list,patch_name)
        			end
        		end
        	end
        end
    end
    return list        
end
