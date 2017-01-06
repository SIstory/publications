$(function () {
    var chart;
    
    $(document).ready(function () {
    	
    	// Build the chart
        $('#chart4').highcharts({
            chart: {
                type: 'pie',
                plotBackgroundColor: null,
                plotBorderWidth: null,
                plotShadow: false
            },
            title: {
                text: 'Družinski stan Judov iz Dravske banovine leta 1937'
            },
            credits: { 
                enabled: false 
            },
            tooltip: {
        	    pointFormat: '<b>{point.percentage:.1f}%</b> ({point.y:,.0f})'
            },
            plotOptions: {
                pie: {
                    allowPointSelect: true,
                    cursor: 'pointer',
                    
                    showInLegend: true
                }
            },
            series: [{
                data: [ 
                    ['ločeni', 12],
                    ['mladoletni', 164],
                    ['poročeni', 363],
                    ['samski', 173],
                    ['vdovski', 58]
                  ]
               }]
        });
    });
    
});
