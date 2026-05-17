<template>
  <view class="container">
    <uni-forms ref="form" :model="form" :rules="rules">
      <uni-forms-item label="字典标签" name="dictLabel">
        <uni-easyinput v-model="form.dictLabel" placeholder="请输入字典标签" />
      </uni-forms-item>
      <uni-forms-item label="字典键值" name="dictValue">
        <uni-easyinput v-model="form.dictValue" placeholder="请输入字典键值" />
      </uni-forms-item>
      <uni-forms-item label="字典排序" name="dictSort">
        <uni-number-box v-model="form.dictSort" />
      </uni-forms-item>
      <uni-forms-item label="状态" name="status">
        <uni-data-checkbox v-model="form.status" :localdata="statusOptions" />
      </uni-forms-item>
      <uni-forms-item label="备注" name="remark">
        <uni-easyinput type="textarea" v-model="form.remark" placeholder="请输入内容" />
      </uni-forms-item>
    </uni-forms>
    
    <view class="footer">
      <button type="primary" @click="submitForm">提交</button>
      <button @click="cancel">取消</button>
    </view>
  </view>
</template>

<script>
import { getData, addData, updateData } from '@/api/system/dict/data'

export default {
  data() {
    return {
      // 表单参数
      form: {
        dictCode: undefined,
        dictLabel: undefined,
        dictValue: undefined,
        dictSort: 0,
        status: "0",
        remark: undefined
      },
      // 表单校验
      rules: {
        dictLabel: [
          { required: true, message: "字典标签不能为空", trigger: "blur" }
        ],
        dictValue: [
          { required: true, message: "字典键值不能为空", trigger: "blur" }
        ]
      },
      // 状态选项
      statusOptions: [
        { text: "正常", value: "0" },
        { text: "停用", value: "1" }
      ]
    }
  },
  onLoad(options) {
    if (options.dictCode) {
      getData(options.dictCode).then(response => {
        this.form = response.data
      })
    } else if (options.dictType) {
      this.form.dictType = options.dictType
    }
  },
  methods: {
    // 表单提交
    submitForm() {
      this.$refs.form.validate().then(valid => {
        if (valid) {
          if (this.form.dictCode != undefined) {
            updateData(this.form).then(response => {
              uni.showToast({ title: "修改成功" })
              uni.navigateBack()
            })
          } else {
            addData(this.form).then(response => {
              uni.showToast({ title: "新增成功" })
              uni.navigateBack()
            })
          }
        }
      })
    },
    // 取消按钮
    cancel() {
      uni.navigateBack()
    }
  }
}
</script>