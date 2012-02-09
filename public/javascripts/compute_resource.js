function ovirt_hwpSelected(item){
  var hwp = $(item).val();
  var url = $(item).attr('data-url');
  $.ajax({
      type:'post',
      url: url,
      data:'hwp_id=' + hwp,
      success: function(result){
        $('[id$=_memory]').val(result.memory);
        $('[id$=_cores]').val(result.cores)
      },
      complete: function(result){
//        $('#hwp_indicator').hide();
//        $('[rel="twipsy"]').twipsy();
      }
    })
}

function ovirt_clusterSelected(item){
  var cluster = $(item).val();
  var url = $(item).attr('data-url');
  $.ajax({
      type:'post',
      url: url,
      data:'cluster_id=' + cluster,
      success: function(result){
        var options = $("[id$=_network]");
        options.empty();
        $.each(result, function() {
            options.append($("<option />").val(this.id).text(this.name));
        });
      },
      complete: function(result){
//        $('#cluster_indicator').hide();
//        $('[rel="twipsy"]').twipsy();
      }
    })
}

$(function(){providerSelected();})

function providerSelected(item){
  var provider = $(item).val();
  if(provider == 'Ovirt')
  {
    $('#compute_resource_uuid').next('.help-inline').text("Enter Data-Center name here");
     $('#compute_resource_uuid').parent().parent().show();
  }
  else
  {
    $('#compute_resource_uuid').next('.help-inline').text("");
     $('#compute_resource_uuid').parent().parent().hide();
  }

}
