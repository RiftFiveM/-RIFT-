$(() => {

    var MusicVideoIndex = 0;
    var MusicVideos = [
        {
            MusicAuthor: 'AB',
            MusicLabel: 'AB Daily duppy',
            MP4Location: 'https://cdn.discordapp.com/attachments/1160931224584474688/1164399974361083914/y2mate.is_-_AB_Daily_Duppy_GRM_Daily-WOlbAr7II-s-1080pp-1697684950.mp4?ex=654312fb&is=65309dfb&hm=9696ad0513eeaeff821d7b110bafde35b19f7b30dbe18af2207ac125adbe9d35&',
            IconLocation: 'https://cdn.discordapp.com/attachments/1160931224584474688/1164400149615869992/image.png?ex=65431325&is=65309e25&hm=01dda963c6c19f397ba86b58aeede4056e41382617f17af5083e0d5e7f9d2b60&'
        },
        {
            MusicAuthor: 'Afganistan',
            MusicLabel: 'Hry Mr Taliban',
            MP4Location: 'https://cdn.discordapp.com/attachments/1160931224584474688/1164400636222259230/y2mate.is_-_Hey_Mr._Taliban_-3rYSYZmWr80-480pp-1697685138.mp4?ex=65431399&is=65309e99&hm=f7573b45fa18bcdf96553debd54ea07496957625e05854c3bec37fea38c04208&',
            IconLocation: 'https://cdn.discordapp.com/attachments/1160931224584474688/1164400539203813466/image.png?ex=65431382&is=65309e82&hm=f2c31f4bf433e51ffdf60bd35c8ecb7066b42313cff1ff3c7e156bcbc5426a13&'
        },
        {   
            MusicAuthor: 'Digga D',
            MusicLabel: 'Chief Rhys Freestyle',
            MP4Location: 'https://cdn.discordapp.com/attachments/1160931224584474688/1164401317545001090/y2mate.is_-_Digga_D_Chief_Rhys_Freestyle_Official_Video_-x_csLde9E2E-1080pp-1697685287.mp4?ex=6543143b&is=65309f3b&hm=e6f5c7484deaa2742384653f98047aaee050bf57d6a6ac72a1ba7472bd333abb&',
            IconLocation: 'https://cdn.discordapp.com/attachments/1160931224584474688/1164401111613055017/hqdefault.png?ex=6543140a&is=65309f0a&hm=9a4c5bb4a2e8f4b125de18727c4d7a39e7c41302fca8140c38caac3b4b4c79e1&'
        },
        {
            MusicAuthor: 'Central C',
            MusicLabel: 'Loading',
            MP4Location: 'https://cdn.discordapp.com/attachments/1160931224584474688/1164402242686812170/y2mate.is_-_Central_Cee_Loading_Music_Video_GRM_Daily-1Ok-i3uGXkM-1080pp-1697685510.mp4?ex=65431518&is=6530a018&hm=32137a8fee9bd9b3cdaeadaca19ce8a87b07642a1cf03fa48fb85de1ac059ba4&',
            IconLocation: 'https://cdn.discordapp.com/attachments/1160931224584474688/1164402159006273586/maxresdefault.png?ex=65431504&is=6530a004&hm=8c5d227c9f918d79d8272c45fb2a3af593dcceec9666a5ece5d03181c692aadd&'
        }
    ];

    var RandomizeArray = (array) => {

        let currentIndex = array.length, randomIndex;
    
        while (currentIndex != 0) {
    
            randomIndex = Math.floor(Math.random() * currentIndex);
            currentIndex--;
    
            [array[currentIndex], array[randomIndex]] = [
                array[randomIndex],
                array[currentIndex]
            ];
            
        };
    
        return array;

    }

    var Slider = document.getElementById('loading_bar');

    Slider.addEventListener('input', (event) => {
        
        let Video = document.getElementById('video');

        Video.currentTime = event.target.value;

    });

    var PlayVideo = (VideoIndex) => {

        var VideoData = MusicVideos[VideoIndex - 1];
        
        $('#loading_toggle').html(`<i class="fa-solid fa-pause"></i>`);

        document.getElementById('loading_video').innerHTML = `

            <video src="${VideoData.MP4Location}" id="video"></video>
                
        `;

        document.getElementById('loading_image').src = VideoData.IconLocation;

        $('#loading_label').text(VideoData.MusicLabel);
        $('#loading_author').text(VideoData.MusicAuthor);

        let Video = document.getElementById('video');

        Video.volume = 0.375;
        Video.play();

        Video.addEventListener('loadedmetadata', function() {

            $('#loading_total').text(new Date(Video.duration * 1000).toISOString().substring(15, 19));
            $('#loading_bar').attr('max', Video.duration);

        });

        Video.addEventListener('timeupdate', () => {
            
            $('#loading_current').text(new Date(Video.currentTime * 1000).toISOString().substring(15, 19));

            if (Video.duration != null && Video.currentTime != null) {

                document.getElementById('loading_bar').value = Video.currentTime;

            };
        
        });

    };

    Back = () => {

        MusicVideoIndex -= 1;

        if (MusicVideoIndex <= 0) {
    
            MusicVideoIndex = MusicVideos.length;

        };

        PlayVideo(MusicVideoIndex);

    };

    Toggle = () => {

        let Video = document.getElementById('video');

        if ($('#video').get(0).paused) {

            Video.play();

            $('#loading_toggle').html(`<i class="fa-solid fa-pause"></i>`);

        } else {

            Video.pause();
            
            $('#loading_toggle').html(`<i class="fa-solid fa-play"></i>`);

        };

    };

    Forward = () => {

        MusicVideoIndex += 1;

        if (MusicVideoIndex > MusicVideos.length) {
    
            MusicVideoIndex = 1;

        };

        PlayVideo(MusicVideoIndex);

    };

    MusicVideos = RandomizeArray(MusicVideos);

    MusicVideoIndex = 1;

    PlayVideo(MusicVideoIndex);

});