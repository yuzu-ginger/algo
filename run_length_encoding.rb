# ランレングス圧縮
# どちらかをコピー

# 文字列
class Array
	def run_length
		self.slice_when{|i, j| i != j }.map{ |x| [x[0], x.size] }
    end
end

# 数値
class Array
	def run_length
		self.slice_when{|i, j| i != j }.map{ |x| [x[0].to_i, x.size] }
    end
end