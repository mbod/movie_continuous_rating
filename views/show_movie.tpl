<!doctype html>

<html>
  <head>
    <title>Continuous rating of movie stimuli - Example</title>


    <!-- Include jQuery -->
    <!--
      <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.8.2/jquery.min.js"></script>
    -->
    <script src="js/jquery.min.js"></script>

    <!-- Include Simple Slider JavaScript and CSS -->
    <script src="js/simple-slider.js"></script>
    <link href="css/simple-slider.css" rel="stylesheet" type="text/css" />

    <script src="js/jquery.flot.min.js"></script>
     


    <style type="text/css">
      #main {
        margin-left: 20%;
      }

      [class^=slider] { display: inline-block; margin-bottom: 30px; }
      .output { color: #888; font-size: 14px;
                padding-top: 1px; margin-left: 5px;
                vertical-align: top;}

      #rating {
        display: none;
        margin-top: 40px;
        margin-left: 100px;
      }

      #placeholder { width: 90%; height: 400px;
                    margin-left: 5%;
      }
    </style>

  </head>
  <body>

    <div id="main">
        <video width="512" height="384" controls>
          <source src="movies/test_movie2.mp4" type="video/mp4">
        </video>

        <div id="rating">
          <!-- Activate Simple Slider on your input -->
          <input id="rating1">
          <!-- type="text"
                data-slider-range="0,100"
                data-slider=true
                data-slider-highlight=true
                data-slider-step=1
          >
        -->
        </input>
        </div>
    </div>
<!--
    <button id="control" onclick="toggleCollection()">Start/Stop</button>
-->

    <div id="placeholder"></div>



    <script>

      var DEBUG=false;
      var startTime=null;
      var log=[];
      var sampleRate=100;

      var url='log_data';

      var options = {
        'range': [0,100],
        'highlight': true,
        'step': 1
      };

      //$("#rating1").simpleSlider( );

      /*
      $("#rating1").bind("slider:changed", function (event, data) {
        // The currently selected value of the slider
        if (startTime) {
          ts = Date.now() - startTime;
          litem = [ts, data.value];
          log.push(litem);
          if (DEBUG) {
            console.log(litem);
          }
        }
      });
      */

      $(document).ready(function(){
        $('video').on('play', toggleCollection);
        $('video').on('ended', toggleCollection);

        $("[data-slider]")
            .each(function () {
              var input = $(this);
              $("<span>")
                .addClass("output")
                .insertAfter($(this));
            })
            .bind("slider:ready slider:changed", function (event, data) {
              $(this)
                .nextAll(".output:first")
                  .html(data.value.toFixed(3));
            });

      });

      function toggleCollection() {
        console.log('in toggle')
          if (!startTime) {
            startTime = Date.now();
            $("#rating1").simpleSlider( options);
            $("#rating").show();

            rating_timer = setInterval(getRating, sampleRate);

          } else {
            clearInterval(rating_timer);
            console.log(log);
            startTime=null;
            $("#rating").hide();
            $('#main').hide();

            $.ajax({url:url,
                    type: 'POST',
                    data: JSON.stringify({'id': '{{ id }}',
                                          'data':log}),
                    contentType:'application/json',
                    success: function(resp) {
                      console.log(resp);
                    }
             });


            $.plot($("#placeholder"), [ log ], { yaxis: { max: 100 } });


          }
      }

      function getRating() {
        if (startTime) {
          var data =$('#rating1').data().sliderObject;
          ts = Date.now() - startTime;
          litem = [ts, data.value];
          log.push(litem);
          if (DEBUG) {
            console.log(litem);
          }
        }
      }

    </script>

  </body>
</html>
