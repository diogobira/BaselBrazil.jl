# RwaJur4

export VERTICES_RWAJUR4,
		RwaJur4Exposure,
		RwaJur4Parameters,
		getLongExposureArray,
		getShortExposureArray,
		#getRwaJur4NetExposure,
		#getRwaJur4VerticalGap,
		#getRwaJur4Zones,
		#getRwaJur4HorizontalGapWithinZones,
		#getRwaJur4HorizontalGapBetweenZones,
		getPJur4,
		getRwaJur4

"""
Standardized vertices for mapping interest rate coupon rate exposures (RWAJUR4)
"""
const VERTICES_RWAJUR4 = VERTICES_RWAJUR2

"""
    RwaJur4Exposure

Holds exposures in interest rate coupon rates.

# Fields
* `date::Date`: date of evaluation
* `VXX::Float64`: exposure to vertex XX, 
given by the sum of present value in BRL 
of all cashflows that matures in XX business days (BD).
 
# Constructors
    RwaJur4Exposure(date::Date)

Create an instance with all exposures equal to zero.
	
	RwaJur4Exposure(date::Date, currency::AbstractString, longExposures::Array{Float64, 1}, shortExposures::Array{Float64, 1})

Create an instance with exposures given by two vectors of length 10 containing long and short exposures.
Exposures are assigned in sequence from vertex 1 BD to vertex 2520 BD.	

"""
type RwaJur4Exposure
	# Date of evaluation
	date::Date
	# Currency
	currency::AbstractString
	# Exposures in standard vertices: VXX, where XX is a maturity calculated in business days
	# LONG EXPOSURES
	V1Long::Float64
	V21Long::Float64
	V42Long::Float64
	V63Long::Float64
	V126Long::Float64
	V252Long::Float64
	V504Long::Float64
	V756Long::Float64
	V1008Long::Float64
	V1260Long::Float64
	V2520Long::Float64
	# SHORT EXPOSURES
	V1Short::Float64
	V21Short::Float64
	V42Short::Float64
	V63Short::Float64
	V126Short::Float64
	V252Short::Float64
	V504Short::Float64
	V756Short::Float64
	V1008Short::Float64
	V1260Short::Float64
	V2520Short::Float64
	
	# Constructors
	RwaJur4Exposure(date::Date, currency::AbstractString) = new(date, currency, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
	
	function RwaJur4Exposure(date::Date, currency::AbstractString, longExposures::Array{Float64, 1}, shortExposures::Array{Float64, 1})                                                     
		if size(longExposures, 1) != 11
			error("long exposures must have 11 values")
		end #if
		if any(longExposures .< 0)
			error("all long exposures must be positive")
		end #if
		
		if size(shortExposures, 1) != 11
			error("short exposures must have 11 values")
		end #if
		if any(shortExposures .< 0)
			error("all short exposures must be positive")
		end #if
		
		new(date,
			currency,		
		    longExposures[1], longExposures[2], longExposures[3], longExposures[4],                      
			longExposures[5], longExposures[6], longExposures[7], longExposures[8],                      
			longExposures[9], longExposures[10], longExposures[11],
			shortExposures[1], shortExposures[2], shortExposures[3], shortExposures[4],                      
			shortExposures[5], shortExposures[6], shortExposures[7], shortExposures[8],                      
			shortExposures[9], shortExposures[10], shortExposures[11]		
			)
	end #function
	
end #type

"""
	RWAJUR4Parameters
	
Holds BCB parameters to calculate interest rate coupon stantardized capital (RWA JUR4)

"""
type RwaJur4Parameters
	date::Date
	M4::Float64
end #type

"""
    getLongExposureArray(rExp::RwaJur4Exposure)

Return a vector with all long exposures in sequence, 
from vertex 1 BD to vertex 2520 BD.
   
"""
getLongExposureArray(rExp::RwaJur4Exposure) = [rExp.V1Long, rExp.V21Long, rExp.V42Long, rExp.V63Long, rExp.V126Long, rExp.V252Long, rExp.V504Long, rExp.V756Long, rExp.V1008Long, rExp.V1260Long, rExp.V2520Long] 

"""
    getShortExposureArray(rExp::RwaJur4Exposure)

Return a vector with all short exposures in sequence, 
from vertex 1 BD to vertex 2520 BD.
    
"""
getShortExposureArray(rExp::RwaJur4Exposure) = [rExp.V1Short, rExp.V21Short, rExp.V42Short, rExp.V63Short, rExp.V126Short, rExp.V252Short, rExp.V504Short, rExp.V756Short, rExp.V1008Short, rExp.V1260Short, rExp.V2520Short] 

# Casts
"""
    convert(::Type{RwaJur2Exposure}, x::RwaJur4Exposure)

Casts an RwaJur4Exposure into an RwaJur2Exposure.
"""
convert(::Type{RwaJur2Exposure}, x::RwaJur4Exposure) = RwaJur2Exposure(x.date, x.currency, getLongExposureArray(x), getShortExposureArray(x))

"""
    convert(::Type{RwaJur2Parameters}, x::RwaJur4Parameters)

Casts an RwaJur4Parameters into an RwaJur2Parameters.
"""
convert(::Type{RwaJur2Parameters}, x::RwaJur4Parameters) = RwaJur2Parameters(x.date, x.M4)	

"""
    getRwaJur4NetExposure(rExp::RwaJur4Exposure)

Return a vector containing RWA JUR4 weighted net exposures.
    
"""
getRwaJur4NetExposure(rExp::RwaJur4Exposure) = getRwaJur2NetExposure(convert(RwaJur2Exposure, rExp))

"""
    getRwaJur4VerticalGap(rExp::RwaJur4Exposure)

Return a vector containing RWA JUR4 vertical gaps.
    
"""
getRwaJur4VerticalGap(rExp::RwaJur4Exposure) = getRwaJur2VerticalGap(convert(RwaJur2Exposure, rExp))

"""
    getRwaJur4Zones(rExp::RwaJur4Exposure)

Return a matrix containing RWA JUR4 zone exposures.
Column 1 contains long exposures, column2 contains short exposures.
Zones are represented in each of the 3 rows.
    
"""
getRwaJur4Zones(rExp::RwaJur4Exposure) = getRwaJur2Zones(convert(RwaJur2Exposure, rExp))

"""
    getRwaJur3HorizontalGapWithinZones(rExp::RwaJur4Exposure)

Return a vector containing RWA JUR4 horizontal gap within zones.
    
"""
getRwaJur4HorizontalGapWithinZones(rExp::RwaJur4Exposure) = getRwaJur2HorizontalGapWithinZones(convert(RwaJur2Exposure, rExp))

"""
    getRwaJur4HorizontalGapBetweenZones(rExp::RwaJur4Exposure)

Return a vector containing RWA JUR4 horizontal gap between zones.
    
"""
getRwaJur4HorizontalGapBetweenZones(rExp::RwaJur4Exposure) = getRwaJur2HorizontalGapBetweenZones(convert(RwaJur2Exposure, rExp))

"""
	getPJur3(rExp::RwaJur4Exposure, par::RwaJur4Parameters)
	
Calculate PJUR4 using maturity ladder methodology.

"""
getPJur4(rExp::RwaJur4Exposure, par::RwaJur4Parameters) = getPJur2(convert(RwaJur2Exposure, rExp), convert(RwaJur2Parameters, par))

"""
	getRwaJur4(rExp::RwaJur4Exposure, par::RwaJur4Parameters)
	
Calculate risk-weighted assets for interest rate coupon exposures (RWA JUR4),
using maturity ladder methodology.
	
"""
getRwaJur4(rExp::RwaJur4Exposure, par::RwaJur4Parameters) = getRwaJur2(convert(RwaJur2Exposure, rExp), convert(RwaJur2Parameters, par))
