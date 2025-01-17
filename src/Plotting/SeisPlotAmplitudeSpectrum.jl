@doc """
Plot amplitude spectrum.
""" ->
function SeisPlotAmplitudeSpectrum(in,param=Dict())

	canvas = get(param, "canvas", "NULL") # called by GUI, or REPL
	fignum = get(param,"fignum",1)
	aspect = get(param,"aspect",2)
	fmax = get(param,"fmax",100) # maximum frequency to plot
	title  = get(param,"title"," ")
	xlabel = get(param,"xlabel","Frequency")
	xunits = get(param,"xunits","(Hz)")
	ylabel = get(param,"ylabel","Amplitude")
	yunits = get(param,"yunits"," ")
	oy = get(param,"oy",0)
	dy = get(param,"dy",0.001)
	dpi = get(param,"dpi",100)
	wbox = get(param,"wbox",4)
	hbox = get(param,"hbox",4)
	name = get(param,"name","NULL")
	interpolation = get(param,"interpolation","none")

	nx = size(in[:,:],2)
	df = 1/dy/size(in[:,:],1)
	FMAX = df*size(in[:,:],1)/2 
	nf = convert(Int32,floor((size(in[:,:],1)/2)*fmax/FMAX))
	y = fftshift(sum(abs(fft(in[:,:],1)),2))/nx
	y = y[int(end/2):int(end/2)+nf]
	norm = maximum(y[:])
	if (norm > 0.)
		y = y/norm
	end
	x = [0:df:fmax]


	if (canvas == "NULL")
		fig = plt.figure(num=fignum, figsize=(wbox, hbox), dpi=dpi, facecolor="w", edgecolor="k")
	else
		fig = canvas[:get_figure]()
	end

	if (canvas != "NULL")
		canvas[:plot](x,y)
	else
		plt.plot(x,y)
		plt.title(title)
		plt.xlabel(join([xlabel " " xunits]))
		plt.ylabel(join([ylabel " " yunits]))

		if (name == "NULL")
			plt.show()
		else  
			plt.savefig(name,dpi=dpi)
			plt.close()
		end
	end
	# set the visual parameters, axis markers, etc
	if (canvas != "NULL")
		canvas[:axis]([0,fmax,0,1.1])
	else
		plt.axis([0,fmax,0,1.1])
	end

end
