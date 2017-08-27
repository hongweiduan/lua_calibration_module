local p = "../"
local m_package_path = package.path
package.path = string.format("%s?.lua;%s", p, m_package_path)

require "test.csv"

function iterator(t)
  local i = 0
    return function()
        i = i + 1
        return t[i]
    end
end
-- bf_tab      = loadCsvFile('~/Desktop/calibration/test/test_data_after_cal.csv')
bf_tab      = loadCsvFile('/Users/howie/Desktop/calibration/test/test_data_before_cal.csv')
bf_tab      = transposition_arrs(bf_tab)
bf_ag_tab   = bf_tab[1]
bf_adc_tab  = bf_tab[2]

af_tab      = loadCsvFile('/Users/howie/Desktop/calibration/test/test_data_after_cal.csv')
af_tab      = transposition_arrs(af_tab)
af_ag_tab   = af_tab[1]
af_adc_tab  = af_tab[2]

------------iterator-------
it_bf_ag    = iterator(bf_ag_tab)
it_bf_adc   = iterator(bf_adc_tab)

it_af_ag    = iterator(af_ag_tab)
it_af_adc   = iterator(af_adc_tab)

