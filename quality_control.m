% check_timing / data consistency
for s=1:length(SUB)
    for c=[30 77 109 126 173 205 237 284 301 333 380]; if ~strcmp(SUB(s).instruction(c),'Push Button'); display(['Warning: ' SUB(s).id ' column ' num2str(c)]); end; end
    if (~strcmp(SUB(s).instruction(396),'Focus') && ~strcmp(SUB(s).instruction(396),'Wander')) ; display(['Warning: ' SUB(s).id ' column 396' ]); end 
    if ~strcmp(SUB(s).instruction(397),'Rest');  display(['Warning: ' SUB(s).id ' column 397' ]); end 
    if strcmp(SUB(s).instruction(396),'Rest');   display(['Warning: ' SUB(s).id ' column 396' ]); end 
    if size(SUB(s).id)          ~=size(SUB(2).id);          display(['Warning: SUB ' num2str(s)  ' id']);           end
    if size(SUB(s).age)         ~=size(SUB(2).age);         display(['Warning: SUB ' num2str(s)  ' age']);          end
    if size(SUB(s).sex)         ~=size(SUB(2).sex);         display(['Warning: SUB ' num2str(s)  ' sex']);          end
    if size(SUB(s).handedness)  ~=size(SUB(2).handedness);  display(['Warning: SUB ' num2str(s)  ' handedness']);   end
    if size(SUB(s).data)        ~=size(SUB(2).data);        display(['Warning: SUB ' num2str(s)  ' data']);         end
    if size(SUB(s).instruction) ~=size(SUB(2).instruction); display(['Warning: SUB ' num2str(s)  ' instruction']);  end
    if size(SUB(s).left_text)   ~=size(SUB(2).left_text);   display(['Warning: SUB ' num2str(s)  ' left_text']);    end
    if size(SUB(s).right_text)  ~=size(SUB(2).right_text);  display(['Warning: SUB ' num2str(s)  ' right_text']);   end
end