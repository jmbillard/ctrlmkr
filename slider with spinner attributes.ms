struct caSliderWithSpinner_source (

	-- contains the item label for the main ui...
	attributeLabel = "slider with spinner",

	-- contains the strings to setup the custom attributes...
	fn setUpUiPrp iS tagcolorS = (

		setPropGrp = \
			"group \" slider with spinner: \" (\n"+\
			"colorpicker tag_color" + iS + " \"\" color:" + tagcolorS + " width:65 height:40 align:#left offset:[-7,0]\n"+\
			"editText sld_name" + iS + " \"\" text:\"edit the name here...\" width:124 height:16 align:#right offset:[0,-44]\n"+\
			"spinner ui_spn_min" + iS + " \"\" width:60 range:[-9999999,9999999,-100] type:#float align:#center offset:[0,0]\n"+\
			"spinner ui_spn_max" + iS + " \"\" width:60 range:[-9999999,9999999,100] type:#float align:#right offset:[0,-21])\n"

		return setPropGrp
		),

	-- contains the strings for the custom attributes rollout...
	fn caParamUi uiIndex rollName colorVal sldName minRange maxRange = (	

		iS = uiIndex as string

		-- sets the parameter block (links the spinner and slider parameters)...
		caParam = "'" + iS + "_" + sldName + "' type:#float ui:(spn" + iS + ",sld" + iS + ")\n"

		-- creates the ui (spinner, slider and color tag)...
		rangeVal = "[" + minRange as string + "," + maxRange as string + "," + minRange as string + "]"

		caUi = \
			"group \" " + sldName + ": \" (\n"+\
			"imgTag img" + iS + " bitmap:(bitmap 2 48 color:" + colorVal as string + ") align:#left\n"+\
			"spinner spn" + iS + " \"\" width:136 range:" + rangeVal + " type:#float scale:0.01 align:#center offset:[2,-50]\n"+\
			"slider sld" + iS + " \"\" width:149 range:" + rangeVal + " ticks:6 align:#center offset:[8,-2]\n)\n"\

		return #(caParam,caUi)
		)
	)

caSliderWithSpinner_source = caSliderWithSpinner_source()