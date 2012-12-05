module LinkbaseTestUtil
  def print_arc(arcs, indent=0)
    arcs.each do |arc|
      if arc.items.nil? || arc.items.size==0
        puts " " * indent * 2 + arc.item_id + "[" + (arc.label if arc.respond_to?(:label)).to_s+"][role "+arc.role.to_s+"][order "+arc.order.to_s+"] = None .. ctx undefined.."
      else 
        arc.items.each do |item|
          print_item(item, arc, indent)
        end        
      end
      print_arc(arc.children, indent+1) if arc.children
    end
  end
  
  def print_item(item, arc, indent, verbose=false)
    
    return if item.nil?
    
    val = item.value
    val = "HTML?" if !val.nil? && val.length > 30
    
    
    ctx = item.context
    if verbose
      puts " " * indent * 2 + arc.item_id + "[" +(arc.label if arc.respond_to?(:label)).to_s+"][balance "+(item.meta["xbrli:balance"] unless item.meta.nil?).to_s+"][role "+arc.role+"][order "+arc.order.to_s+"] = " + val + " .. ctx .." + ctx.id + " dimension-domain : " + ctx.explicit_dimensions_domains.inject("") {|_s, k| _s + k[0] + ":" + k[1].to_s+", " } 
    else
      puts " " * indent * 2 + (arc.label if arc.respond_to?(:label)).to_s+"   " + val + " .. ctx .." + ctx.id + " dimension-domain : " + ctx.explicit_dimensions_domains.inject("") {|_s, k| _s + k[0] + ":" + k[1].to_s+", " }
    end
  end
  
  def print_arc_no_domains(arcs, period=nil,indent=0)
    arcs.each do |arc|
      if arc.items.nil? || arc.items.size==0
        #puts " " * indent * 2 + (arc.label if arc.respond_to?(:label)).to_s
      else
        val_all=""
        arc.items.each do |item|
          val_all=item_val(item, arc, nil, period, indent)
          val_all +=" [balance "+(item.meta["xbrli:balance"] unless item.meta.nil?).to_s+"]" unless val_all=="-"
          break unless val_all=="-"         
        end
        puts " " * indent * 2 + (arc.label if arc.respond_to?(:label)).to_s+"|" + val_all.to_s
      end
      print_arc_no_domains(arc.children, period, indent+1) if arc.children
    end
  end
  
  def print_arc_for_domains(arcs, domains=nil, period=nil,indent=0)
    
    domain_heading="|"
    domains.each do |domain|
      domain_heading += domain.to_s + "|"
    end
    
    puts domain_heading if indent==0
    
    arcs.each do |arc|
      if arc.items.nil? || arc.items.size==0
        #puts " " * indent * 2 + (arc.label if arc.respond_to?(:label)).to_s
      else
        val_all=""
        domains.each do |domain|
          val="-"
          arc.items.each do |item|            
            val=item_val(item, arc, domain, period, indent)
            val +=" [balance "+(item.meta["xbrli:balance"] unless item.meta.nil?).to_s+"]" unless val=="-"            
            break unless val=="-"
          end
          val_all += val + "|"
        end
        puts " " * indent * 2 + (arc.label if arc.respond_to?(:label)).to_s+"|" + val_all.to_s
      end
      print_arc_for_domains(arc.children, domains, period, indent+1) if arc.children
    end
  end
  
  
  def item_val(item, arc, domain, period, indent, verbose=false)
    
    return "-" if item.nil?
    
    val = item.value
    val = "HTML?" if !val.nil? && val.length > 30
    
    ctx = item.context
    
    return "-" unless ctx.period.to_s==period.to_s unless period.nil?
    
    return val.to_s if domain.nil? 
    
    ctx.domain.each do |dom|
      return val.to_s if dom==domain
    end unless domain.nil?
    
    return "-"    
    
  end  
end